defmodule Calc do
  @moduledoc """
  Module that contains function to evaluate an infix expression
  """

  @doc """
  Function to check if a character is an operator
  """
  def is_operator(op) do
    if (op == "+") || (op == "-") || (op == "*") || (op == "/") do
      true
    else
      false
    end
  end


  @doc """
  Function to check if op1 is of higher predence than op2
  """
  def is_op1_higher_precedence(op1, op2) do
    cond do
      (op2 == "(") -> true
      ((op1 == "*") && (op2 == "+")) || ((op1 == "/") && (op2 == "+")) ||
        ((op1 == "*") && (op2 == "-")) || ((op1 == "/") && (op2 == "-")) -> true
      true -> false
    end
  end

  @doc """
  Helper method to recursively apply operator to operands until a operator of lower precendence is reached
  """
  def recursive_pop_and_compute(op, stacks, check_precedence) do
    cond do
      (check_precedence && (
        Stack.is_empty(stacks[:operatorStack]) or is_op1_higher_precedence(
          op,
          Stack.top(stacks[:operatorStack])
        ))) ->
        # stop recursion and return
        [
          {:operandStack, stacks[:operandStack]},
          {:operatorStack, Stack.push(stacks[:operatorStack], op)}
        ]
      (Stack.is_empty(stacks[:operatorStack])) -> stacks
      true ->
        # compute operation result, and recursively invoke the function
        recursive_pop_and_compute(op, compute_stack_tops(stacks), check_precedence)
    end
  end

  @doc """
  Helper method that recursively pops elements from stack and compute values until it sees a closing bracket
  """
  def recursive_pop_and_compute_until_closingbracket(stacks) do
    cond do
      (Stack.is_empty(stacks[:operatorStack])) -> raise "Unbalanced brackets"
      (Stack.top(stacks[:operatorStack]) == "(") ->
        [
          {:operandStack, stacks[:operandStack]},
          {:operatorStack, elem(Stack.pop(stacks[:operatorStack]), 1)}
        ]
      true ->
        recursive_pop_and_compute_until_closingbracket(compute_stack_tops(stacks))
    end
  end

  @doc """
  Helper method that handles processing an element and adding it to the stack
  """
  def process_element(element, stacks) do
    cond do
      #if integer valid to stack
      (Integer.parse(element) != :error) ->
        [
          {:operandStack, Stack.push(stacks[:operandStack], elem(Integer.parse(element), 0))},
          {:operatorStack, stacks[:operatorStack]}
        ]
      # handle operators
      is_operator(element) ->
        cond do
          # push to stack if empty
          Stack.is_empty(stacks[:operatorStack]) ->
            # push to stack
            [
              {:operandStack, stacks[:operandStack]},
              {:operatorStack, Stack.push(stacks[:operatorStack], element)}
            ]
          is_op1_higher_precedence(element, Stack.top(stacks[:operatorStack])) ->
            # push to stack if higher precedence
            [
              {:operandStack, stacks[:operandStack]},
              {:operatorStack, Stack.push(stacks[:operatorStack], element)}
            ]
          true ->
            # pop and continue evaluating from stack
            recursive_pop_and_compute(element, stacks, true)

        end
      element == ")" -> recursive_pop_and_compute_until_closingbracket(stacks)
      element == "(" ->
        # push to stack
        [
          {:operandStack, stacks[:operandStack]},
          {:operatorStack, Stack.push(stacks[:operatorStack], element)}
        ]
      true -> raise "Invalid operator or operand found"
    end
  end

  @doc """
  Helper method to compute/Lookup result from the stack
  """
  def find_result_from_stack(result_stack) do
    cond do
      (Stack.size(result_stack[:operandStack]) == 1) -> Stack.top(result_stack[:operandStack])
      (Stack.size(result_stack[:operandStack]) == 0) -> raise "Not a valid infix expression"
      true ->
        #apply operands to operators
        final_stack = recursive_pop_and_compute(nil, result_stack, false)
        if (Stack.size(final_stack[:operandStack]) == 1) do
          Stack.top(final_stack[:operandStack])
        else
          raise "Not a well formed infix expression"
        end
    end
  end


  @doc """
  Function that applies the operand to the first two operatands of the stack.
  Returns new stack.
  """
  def compute_stack_tops(stacks) do
    {op2, poped_stack} = Stack.pop(stacks[:operandStack])
    {op1, opnd_stack} = Stack.pop(poped_stack)
    {operator, operator_stack} = Stack.pop(stacks[:operatorStack])
    computed_result = compute(op1, op2, operator)
    current_stacks = [
      {:operandStack, Stack.push(opnd_stack, computed_result)},
      {:operatorStack, operator_stack}

    ]
    current_stacks
  end


  @doc """
  Function to applies the operator to the two operands, and returns the result
  """
  def compute(operand1, operation2, operator) do
    cond do
      (operator == "+") -> (operand1 + operation2)
      (operator == "-") -> (operand1 - operation2)
      (operator == "*") -> (operand1 * operation2)
      (operator == "/" && operation2 == 0) -> raise "Encountered divide by zero"
      (operator == "/") -> div(operand1, operation2)
    end
  end


  @doc """
  Function that evaluates an expression and returns the result
  """
  def eval(expression) do
    # preprocess and split string
    expression_list = expression
                      |> String.replace("(", " ( ")
                      |> String.replace(")", " ) ")
                      |> String.split()

    try do
      # reduce the elements of the expression
      result_stack = Enum.reduce(
        expression_list,
        #accumulator
        [{:operandStack, []}, {:operatorStack, []}],
        fn (element, stacks) ->
          process_element(element, stacks)
        end
      )

      # compute result from the stack
      find_result_from_stack(result_stack)

    rescue
      #handle any exception raised
      e in RuntimeError -> "Error: " <> e.message
    end
  end

  @doc """
  Function that repeatedly prompts user for an expression and evaluates the expression
  """
  def main do
    IO.gets("Enter expression to evaluate: ")
    |> eval
    |> IO.puts
    main()
  end

end



