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
    
    compute_sub_expressions_in_brackets(expression) if expression.include?('(')

    #-> sanitize operands
    #-> 1. check to see if operands are multiple digits or signed if so, concatenate them

    expression = sanitize_inputs(expression) 
    expression
    
    expression = compute_expression(expression)

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
      sanitize_exp << e && next unless String === e 

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

  def compute_expression(expression)
    if expression.length == 3
      raise ZeroDivisionError if expression.last.zero?

      return [expression[0].send(expression[1], expression[2])] 
    end

    ['/', '*', '+', '-'].each do |op|
      while expression.include?(op)
        op_index = expression.find_index(op)
        
        operand1 = expression[op_index-1]
        operand2 = expression[op_index+1]


        # determine if operands are signed or not and do this only if
        # operands are + or -. For other operators signature of operand does not
        # matter.
        if ['-', '+'].include?(op)
          if expression[op_index-2] == '-'
            operand1 = -operand1
            sign_index = op_index - 2
          end

          if expression[op_index+1] == '-'
            operand2 = -operand2
          end
        end

        
        result = operand1.send(op, operand2)

        raise ZeroDivisionError if result.infinite?

        if sign_index
          expression[(op_index-1)..(op_index+1)] = result
          expression[sign_index] = '-' if result < 0 
          expression[sign_index] = '+' if result >= 0
          sign_index = nil
        else
          expression[(op_index-1)..(op_index+1)] = result
        end
      end
    end

    expression
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

  def compute_sub_expressions_in_brackets(expression) 
    # find bracket 
    # find if single bracket, i.e if bracket is immediately followed by number or sign(-)
    # if single bracket, find closing bracket and extract sub expression 
    # compute sub expression and replace bracket expression with computed result 
    # repeat 1-4 til no bracket is found and is just normal expression remaining
    #compute normal expression and return answer

    # if nested brackets, i.e, if bracket is followed by one or more bracket, find all
    # opening brackets.
    # take the last opening bracket and find it's corresponding closing bracket, extract sub 
    # expression and compute, replace the nested bracket expression with computed result.
    # move on to the next bracket and repeat 6-10 til only normal expression is left
    # compute remain normal expression and return answer

    # byebug

    nested_brackets = []
    sub_expression = []

    while expression.include?('(') do 
      opening_bracket_index = expression.find_index('(')

      if bracket_is_nested?(opening_bracket_index, expression)
        nested_brackets << opening_bracket_index 
        next
      end

      if nested_brackets.any? 
        #look for all closing brackets
      end
      
      closing_bracket_index = expression.find_index(')')

      sub_expression = expression[(opening_bracket_index.+1)..(closing_bracket_index-1)]
      
      sub_expression = sanitize_inputs(sub_expression)
      result_array = compute_expression(sub_expression)

      result = result_array[0].round(3)
      
      expression[opening_bracket_index..closing_bracket_index] = result 
    end
  end

  def bracket_is_nested?(opening_bracket_index, expression)
    next_e = expression[opening_bracket_index+1]

    next_e == '('
  end
end


