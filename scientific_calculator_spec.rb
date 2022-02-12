require 'rspec'
require_relative 'scientific_calculator'

RSpec.describe ScientificCalculator do
  describe 'perform simple arithmetic' do
    let(:calculator) { ScientificCalculator.new }

    describe 'single operations' do
      context 'simple addtion' do
        it '4+5' do
          expression = '4+5'
          expect(calculator.solve(expression: expression)).to eq(9.0)
        end

        it '5.0+4.589' do
          expression = '5.0+4.589'
          expect(calculator.solve(expression: expression)).to eq(9.589)
        end

        it '123+800' do
          expression = '123+800'
          expect(calculator.solve(expression: expression)).to eq(923)
        end
      end

      context 'simple substraction' do
        it '-4-8+9' do
          expression = '-4+-808/-99'
          expect(calculator.solve(expression: expression)).to eq(4.162)
        end

         it '-4-10' do
          expression = '-4-10'
          expect(calculator.solve(expression: expression)).to eq(-14)
        end

        it '4--10' do
          expression = '4--10'
          expect(calculator.solve(expression: expression)).to eq(14.0)
        end

        it '-4--10' do
          expression = '-4--10'
          expect(calculator.solve(expression: expression)).to eq(6.0)
        end
      end

      context 'simple multiplication' do
        it '4*10' do
          expression = '4*10'
          expect(calculator.solve(expression: expression)).to eq(40.0)
        end

        it '-4*10' do
          expression = '-4*10'
          expect(calculator.solve(expression: expression)).to eq(-40.0)
        end
      end

      context 'simple division' do
        it '4/10' do
          expression = '4/10'
          expect(calculator.solve(expression: expression)).to eq(0.4)
        end

        it '-4/10' do
          expression = '-4/10'
          expect(calculator.solve(expression: expression)).to eq(-0.4)
        end

        it '4/0' do
          expression = '4/0'
          expect { calculator.solve(expression: expression) }.to raise_error(ZeroDivisionError)
        end

        it '8/2/2' do 
          expression = '8/2/2'
          expect(calculator.solve(expression: expression)).to eq(2.0)
        end
      end
    end

    # describe 'single bracket sets in multiple operations'
  end

#   describe 'perform arithmetic with one or more sets of brackets present'
#   describe 'perform arithmetic with nested brackets'
end
