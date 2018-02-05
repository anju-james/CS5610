defmodule CalcTest do
  use ExUnit.Case
  doctest Calc

  test "valid operators" do
    assert Calc.is_operator("+") == true
    assert Calc.is_operator("-") == true
    assert Calc.is_operator("*") == true
    assert Calc.is_operator("/") == true
  end

  test "invalid operators" do
    assert Calc.is_operator("a") == false
    assert Calc.is_operator("1") == false
    assert Calc.is_operator("+-") == false
  end


  test "eval basic evals" do
    assert Calc.eval("1 + 2") == 3
    assert Calc.eval("1 + 2 +  7") == 10
    assert Calc.eval("2 - 2") == 0
    assert Calc.eval("2 - 2 - 3") == -3
    assert Calc.eval("2 - 0 - 2") == 0
    assert Calc.eval("4 / 2") == 2
    assert Calc.eval("4 / 2 / -2") == -1
    assert Calc.eval("2 * 3") == 6
    assert Calc.eval("2 * -2 * 5") == -20
  end

  test "eval with nested brackets" do
    assert Calc.eval("5 * (1 - 1)") == 0
    assert Calc.eval("5 * ((1 + 1) + 1)") == 15
    assert Calc.eval("(5 * ((1 + 1) + 1)) / 5") == 3
    assert Calc.eval("(5) + (5 * ((1 + 1) + 1)) / 5") == 8
    assert Calc.eval("(5) +(5 * (( 1 + 1) + 1))/ 5") == 8
  end

  test "compute function" do
    assert Calc.compute(1, 2, "+") == 3
    assert Calc.compute(1, -2, "+") == -1
    assert Calc.compute(1, 2, "-") == -1
    assert Calc.compute(1, -2, "-") == 3
    assert Calc.compute(3, 2, "*") == 6
    assert Calc.compute(6, -3, "/") == -2
    assert_raise RuntimeError, ~r/Encountered divide by zero/, fn ->
      Calc.compute(6, 0, "/")
    end
  end

  test "check precedence" do
    assert Calc.is_op1_higher_precedence("/", "+") == true
    assert Calc.is_op1_higher_precedence("*", "+") == true
    assert Calc.is_op1_higher_precedence("/", "(") == true
    assert Calc.is_op1_higher_precedence("+", "(") == true
    assert Calc.is_op1_higher_precedence("+", "-") == false
    assert Calc.is_op1_higher_precedence("+", "*") == false
  end

  test "compute stack tops" do
    stacks = Calc.compute_stack_tops([{:operandStack, [1, 2]}, {:operatorStack, ["+"]}])
    assert Stack.size(stacks[:operandStack]) == 1
    assert Stack.is_empty(stacks[:operatorStack]) == true
    assert Stack.top(stacks[:operandStack]) == 3

    stacks = Calc.compute_stack_tops([{:operandStack, [2, 6]}, {:operatorStack, ["/"]}])
    assert Stack.size(stacks[:operandStack]) == 1
    assert Stack.is_empty(stacks[:operatorStack]) == true
    assert Stack.top(stacks[:operandStack]) == 3

    stacks = Calc.compute_stack_tops([{:operandStack, [2, 6, 4]}, {:operatorStack, ["/", "+"]}])
    assert Stack.size(stacks[:operandStack]) == 2
    assert Stack.is_empty(stacks[:operatorStack]) == false
    assert stacks[:operandStack] == [3, 4]

    stacks = Calc.compute_stack_tops(stacks)
    assert Stack.size(stacks[:operandStack]) == 1
    assert Stack.is_empty(stacks[:operatorStack]) == true
    assert Stack.top(stacks[:operandStack]) == 7
  end

  test "find valid result from stack" do
    assert Calc.find_result_from_stack([{:operandStack, [1, 2]}, {:operatorStack, ["+"]}]) == 3
    assert Calc.find_result_from_stack([{:operandStack, [1]}, {:operatorStack, []}]) == 1
  end

  test "find result from stack" do
    assert_raise RuntimeError, ~r/Not a well formed infix expression/, fn ->
      Calc.find_result_from_stack([{:operandStack, [1, 2]}, {:operatorStack, []}])
    end
  end

  test "process element" do
    # process number
    resultStack = Calc.process_element("1", [{:operandStack, []}, {:operatorStack, []}])
    assert Stack.top(resultStack[:operandStack]) == 1
    # process a operator
    resultStack = Calc.process_element("+", [{:operandStack, []}, {:operatorStack, []}])
    assert Stack.top(resultStack[:operatorStack]) == "+"
    # process a bracket
    resultStack = Calc.process_element("(", [{:operandStack, []}, {:operatorStack, []}])
    assert Stack.top(resultStack[:operatorStack]) == "("
  end

  test "pop until closing bracket" do
    # process number
    resultStack = Calc.recursive_pop_and_compute_until_closingbracket(
      [{:operandStack, [1, 2]}, {:operatorStack, ["+", "("]}]
    )
    assert Stack.top(resultStack[:operandStack]) == 3
    # process with multiple brackets
    resultStack = Calc.recursive_pop_and_compute_until_closingbracket(
      [{:operandStack, [1, 2]}, {:operatorStack, ["+", "(", "+", "("]}]
    )
    assert Stack.top(resultStack[:operandStack]) == 3
  end

  test "recursive pop and compute" do
    # with precedence check
    resultStack = Calc.recursive_pop_and_compute("+",
      [{:operandStack, [1, 2]}, {:operatorStack, ["+"]}], true)
    assert Stack.top(resultStack[:operandStack]) == 3
    assert Stack.top(resultStack[:operatorStack]) == "+"

    # no predence check
    resultStack = Calc.recursive_pop_and_compute(nil,
      [{:operandStack, [1, 2]}, {:operatorStack, ["+"]}], false)
    assert Stack.top(resultStack[:operandStack]) == 3
    assert Stack.is_empty(resultStack[:operatorStack]) == true
  end
  

end
