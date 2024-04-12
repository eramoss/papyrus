defmodule Papyrus do
  defmodule Utils do
     def inverse_multiplier(a, m) do
       if a == 0 do
         raise ArgumentError, "Cannot divide by zero"
       else
         -m / a
       end
     end
  end
end
