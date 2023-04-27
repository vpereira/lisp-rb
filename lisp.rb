# frozen_string_literal: true

require 'readline'

def tokenize(code)
  code = code.gsub('(', ' ( ').gsub(')', ' ) ')
  tokens = []
  until code.empty?
    case code
    when /\A"([^"]*)"/ # Match a double-quoted string with optional spaces
      tokens << "\"#{Regexp.last_match(1)}\""
      code = code[(Regexp.last_match(0).length)..].lstrip
    else
      token, rest = code.split(' ', 2)
      tokens << token
      code = rest.to_s.lstrip
    end
  end
  tokens
end

def parse(tokens)
  return nil if tokens.empty?

  token = tokens.shift
  case token
  when '('
    list = []
    list << parse(tokens) while tokens.first != ')'
    tokens.shift # Discard ')'
    list
  when ')'
    raise SyntaxError, 'Unexpected )'
  when /^"([^"]*)"$/
    token[1..-2] # Extract the string content without the double quotes
  when /^-?\d+$/ # Corrected regex for integer
    token.to_i
  when /^-?\d+(\.\d+)?$/ # Corrected regex for float
    token.to_f
  else
    token.to_sym
  end
end

def eval_ast(ast, env)
  case ast
  when Symbol
    env[ast]
  when Array
    case ast[0]
    when :if
      _, test, conseq, alt = ast
      expr = eval_ast(test, env) ? conseq : alt
      eval_ast(expr, env)
    when :loop
      _, test, *body = ast
      last_result = nil
      loop_counter = 0
      loop do
        env[:_] = loop_counter
        break unless eval_ast(test, env)

        body.each { |expr| last_result = eval_ast(expr, env) }
        loop_counter += 1
      end
      last_result
    when :repeat
      _, count, *body = ast
      count_val = eval_ast(count, env)
      last_result = nil
      count_val.times do |i|
        env[:_] = i + 1
        body.each { |expr| last_result = eval_ast(expr, env) }
      end
      last_result
    else
      func = eval_ast(ast[0], env)
      args = ast[1..].map { |arg| eval_ast(arg, env) }
      func.call(*args)
    end
  else
    ast
  end
end

def global_env
  {}.tap do |env|
    env.update({
                 :+ => ->(*args) { args.inject(:+) },
                 :- => ->(*args) { args.inject(:-) },
                 :* => ->(*args) { args.inject(:*) },
                 :/ => ->(*args) { args.inject(:/) },
                 :< => ->(a, b) { a < b },
                 :> => ->(a, b) { a > b },
                 :print => lambda { |*args|
                             print_str = args.join(' ')
                             puts print_str
                             print_str.chomp
                           },
                 :_ => 0
               })
  end
end

def repl(env, prompt = '> ')
  loop do
    code = Readline.readline(prompt, true)
    open_parens = code.count('(')
    close_parens = code.count(')')

    while open_parens > close_parens
      print "#{' ' * (prompt.length - 1)}| "
      line = Readline.readline('', true)
      code += " #{line}"
      open_parens += line.count('(')
      close_parens += line.count(')')
    end

    if code.nil? || code.strip == 'exit'
      puts "\nExiting REPL..."
      break
    end

    tokens = tokenize(code)
    ast = parse(tokens)
    result = eval_ast(ast, env)
    puts result.inspect unless result.nil?
  end
end

def main
  Signal.trap('INT') do
    puts "\nInterrupted! Type 'exit' to quit the REPL."
  end

  repl(global_env)
end

main if __FILE__ == $PROGRAM_NAME
