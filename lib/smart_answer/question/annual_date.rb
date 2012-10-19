require 'date'

module SmartAnswer
  module Question
    class AnnualDate < SmartAnswer::Question::Date 
      def initialize(name, &block)
        super
      end
      def parse_input(input)
        puts "AnnualDate#parse_input(#{input})"
        date = case input
        when Hash, ActiveSupport::HashWithIndifferentAccess
          input = input.symbolize_keys
          ::Date.parse("#{input[:year]}-#{input[:month]}-#{input[:day]}")
        when String
          ::Date.parse("#{::Date.today.year}-#{input}")
        when Date
          input
        else
          raise InvalidResponse, "Bad date", caller
        end
        date.strftime('%m-%d')
      end  
      
      def to_response(input)
        date = ::Date.parse(parse_input("#{::Date.today.year}-#{input}"))
        {
          day: date.day,
          month: date.month,
          year: date.year
        }
      rescue
        nil
      end
    end
  end
end
