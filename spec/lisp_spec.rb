# frozen_string_literal: true

require_relative '../lisp' # Update the path to your Lisp interpreter file
require 'rspec'

RSpec.describe 'Lisp interpreter' do
  let(:env) { global_env }

  def eval_code(code)
    tokens = tokenize(code)
    ast = parse(tokens)
    eval_ast(ast, env)
  end

  # use it to test print operations
  def capture_stdout
    old_stdout = $stdout
    $stdout = StringIO.new
    yield
    $stdout.string
  ensure
    $stdout = old_stdout
  end

  describe '#tokenize' do
    describe 'let' do
      it 'binds a variable to a value' do
        code = '(let (x 42) x)'
        result = eval_code(code)
        expect(result).to eq(42)
      end

      it 'binds multiple variables to their respective values' do
        code = '(let (x 2 y 3) (+ x y))'
        result = eval_code(code)
        expect(result).to eq(5)
      end
    end

    it 'ignores comments starting with ;' do
      code = <<-CODE
        ; This is a comment
        (print "Hello, World!") ; Another comment
      CODE

      expected_tokens = ['(', 'print', '"Hello, World!"', ')']
      expect(tokenize(code)).to eq(expected_tokens)
    end
  end

  context 'Arithmetic operations' do
    it 'adds numbers' do
      expect(eval_code('(+ 3 5)')).to eq(8)
    end

    it 'subtracts numbers' do
      expect(eval_code('(- 10 4)')).to eq(6)
    end

    it 'multiplies numbers' do
      expect(eval_code('(* 5 8)')).to eq(40)
    end

    it 'divides numbers' do
      expect(eval_code('(/ 20 5)')).to eq(4)
    end
  end

  context 'Comparisons' do
    it 'compares less than' do
      expect(eval_code('(< 4 10)')).to eq(true)
    end

    it 'compares greater than' do
      expect(eval_code('(> 7 2)')).to eq(true)
    end
  end

  context 'Conditionals' do
    it 'evaluates true condition' do
      expect(eval_code('(if (< 5 10) "less" "greater")')).to eq('less')
    end

    it 'evaluates false condition' do
      expect(eval_code('(if (> 5 10) "less" "greater")')).to eq('greater')
    end
  end

  context 'Print' do
    it { expect(eval_code('(print "Hello")')).to eq('Hello') }
    it { expect(eval_code('(print "Hello World")')).to eq('Hello World') }
  end

  context 'Loop and repeat' do
    it 'evaluates loop and repeat with print' do
      expect(eval_code('(loop (< _ 2) (print "Hello"))')).to eq('Hello')
      expect(eval_code('(loop (< _ 2) (print "Hello, world!"))')).to eq('Hello, world!')
    end
  end
end
