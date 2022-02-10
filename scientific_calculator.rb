require 'byebug'

class ScientificCalculator
  attr_accessor :expression
  BODMAS_RULE = ['(', ')', '/', '*', '+', '-'].freeze

  def initialize
    # might initialize sthg here later
  end

  def solve(expression:)
    expression = expression.nil? ? self.expression : expression
    evaluate(expression)
  end

  private

  def evaluate(expression)
    #-> split expression into an array of operands and operators
    expression_array = expression.split('')

    x = ''
    formatted_expression = []
    expression_array.each.with_index do |e, index|
      if is_operand?(e) || e == '.'
        x << e
      elsif !is_operand?(e)
        formatted_expression << [x, e]
        x = ''
      end

      formatted_expression.flatten!
      formatted_expression << x if index == (expression_array.length - 1)
    end

    formatted_expression[0].to_f.send(formatted_expression[1], formatted_expression[2].to_f)
  end

  def is_operand?(e)
    Float(e)
  rescue ArgumentError
    nil
  end
end
