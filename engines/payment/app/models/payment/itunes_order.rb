module Payment
  class ItunesOrder < RemoteOrder
    def verify_receipt!
      with_lock do
        receipt = Itunes::Receipt.verify!(nonce_str, GlobalSettings.itunes.allow_sandbox)
        return unless validate_receipt(receipt)
        product = ItunesProduct.find_by(product_id: receipt.product_id)
        save_valid_receipt!(receipt, product)
      end
    rescue Itunes::Receipt::ReceiptServerOffline => e
      raise e
    rescue Itunes::Receipt::VerificationFailed => e
      save_invalid_receipt!(e.status)
      raise e
    end

    class << self
      def check_recharge(user, receipt_data, transaction_id, itunes_product)
        recharge = ::Payment::Recharge.find_by(transaction_no: transaction_id)
        recharge = create_init_recharge!(user, transaction_id, itunes_product) if recharge.blank?
        itunes_order = recharge.remote_order
        return recharge if itunes_order.paid?
        itunes_order.with_lock do
          itunes_order.nonce_str = receipt_data
          itunes_order.save
          itunes_order.verify_receipt! unless itunes_order.paid?
        end
        recharge
      end

      def create_init_recharge!(user, transaction_id, itunes_product)
        user.payment_recharges.create(
          amount: itunes_product.amount,
          pay_type: 'itunes',
          source: :app,
          transaction_no: transaction_id
        )
      end
    end

    private

    def save_valid_receipt!(receipt, product)
      pay!
    end

    def save_invalid_receipt!(status)
    end

    def validate_receipt(receipt)
      raise Payment::InvalidNotify, '非法通知' unless (receipt.bid || receipt.bundle_id) == GlobalSettings.itunes.bid
      raise Payment::InvalidNotify, '非法通知' unless receipt.transaction_id == order_no
    end
  end
end
