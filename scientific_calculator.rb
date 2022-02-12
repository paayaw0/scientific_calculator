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
    expression = expression.split('')
    #-> sanitize operands
    #-> 1. check to see if operands are multiple digits or signed if so, concatenate them
    
    expression = sanitize_inputs(expression)
    expression
    
    sub_expressions = []
    # get expressions in brackets and store sub_expressions array
    
    ['/', '*', '+', '-'].each do |op|
      while expression.include?(op)
        op_index = expression.find_index(op)
        
        operand1 = expression[op_index-1]
        operand2 = expression[op_index+1]
        
        result = operand1.send(op, operand2)

        raise ZeroDivisionError if result.infinite?

        expression[(op_index-1)..(op_index+1)] = result
      end
    end

    expression[0].round(3)
  end

  def is_operand?(e)
    Float(e)
  rescue ArgumentError
    false
  end

  def is_operator?(e)
    !is_operand?(e)
  end

  def sanitize_inputs(expression)
    sanitize_exp = []
    x = ''
    last_index = expression.length - 1

    expression.each.with_index do |e, index|
      next_e = expression[index != last_index ? index + 1 : index]
      
      if is_operand?(next_e)
        if is_a_sign?(e, index, expression) || is_multiple_digits_or_includes_decimal?(e, next_e)
          x << e
          next
        end

        sanitize_exp << e
      else
        if e == '.' || next_e == '.'
          x << e
          next
        end

        x << e
        sanitize_exp << x 
        x = ''
      end
    end

    sanitize_exp << x unless x.empty?
    sanitize_exp.map! do |i| 
      Float(i)
    rescue ArgumentError
      i
    end
  end

  def is_a_sign?(e, index, expression)
    last_index = expression.length - 1
    prev_e = expression[index != 0 ? index - 1 : index]
    next_e = expression[index != last_index ? index + 1 : index]
    
    (is_operator?(prev_e) && is_operand?(next_e) && is_operator?(e)) 
  end

  def is_multiple_digits_or_includes_decimal?(e, next_e)
    (is_operand?(next_e) && is_operand?(e)) || next_e == '.' || e == '.'
  end
end


