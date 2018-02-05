defmodule Stack do
  @moduledoc """
  Module that contains functions to support stack operation
  """

  @doc """
  Returns size of the stack
  """
  def size(stack) do
    Enum.count(stack)
  end

  @doc """
  Function that pops the top of the stack and returns tuple of the popped element and remaining stack
  """
  def pop(stack) do
    [top | remaining] = stack
    {top, remaining}
  end

  @doc """
  Function that returns a stack after pushing the element
  """
  def push(stack, element) do
    [element | stack]
  end

  @doc """
  Function that peeks top of the stack without popping
  """
  def top(stack) do
    hd(stack)
  end

  @doc """
  Function that checks if the stack is empty and returns true if it is, false otherwise
  """
  def is_empty(stack) do
    if size(stack) == 0 do
      true
    else
      false
    end
  end

end