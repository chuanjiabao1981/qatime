module QaStateMachine
  extend ActiveSupport::Concern
  module ClassMethods



  def __event_actions(state_machine_class)
    puts "1000000000000"
    state_machine_class.state_machines[:state].events.map(&:name).each do |event|
      puts "1111111"
      define_method(event) do
        puts "===========================================#{event}"
        # puts @exercise
        puts "0000000----------------"
        @exercise.state_event = event
        @exercise.save
        @object_state         = @exercise
      end
    end
  end
  end
end