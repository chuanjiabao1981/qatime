module Payment
  class ItunesOrder < RemoteOrder
    class << self
      def check_recharges(user, receipt_data, transaction_id)
        recharge = find_or_init_recharge!(user, transaction_id, receipt_result(receipt_data, transaction_id))
        itunes_order = recharge.remote_order
        itunes_order.with_lock do
          unless itunes_order.paid?
            itunes_order.nonce_str = receipt_data
            itunes_order.save
            itunes_order.pay!
          end
        end
        recharge.reload
      end

      def receipt_result(receipt_data, transaction_id)
        receipt = Itunes::Receipt.verify!(receipt_data, GlobalSettings.itunes.allow_sandbox)
        raise Payment::InvalidNotify, '非法通知' unless receipt.bundle_id == GlobalSettings.itunes.bid
        receipt.in_app.find {|item| item.transaction_id == transaction_id }
      end

      def find_or_init_recharge!(user, transaction_id, receipt_result)
        itunes_product = Payment::ItunesProduct.find_by(product_id: receipt_result.product_id)
        recharge = Payment::Recharge.find_by(transaction_no: transaction_id)
        recharge ||= user.payment_recharges.create(
          amount: itunes_product.amount,
          pay_type: 'itunes',
          source: :app,
          transaction_no: transaction_id
        )
        recharge
      end
    end
  end
end
