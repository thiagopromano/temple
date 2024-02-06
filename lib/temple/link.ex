defmodule Temple.Link do
  alias PhoenixHTMLHelpers
  alias Temple.Utils

  @moduledoc """
  This modules wraps all of the functions from the `PhoenixHTMLHelpers.Link` module to make them compatible with with Temple.
  """

  @doc """
  Please see `PhoenixHTMLHelpers.Link.link/2` for details.
  """
  defmacro phx_link(opts, do: block) do
    quote location: :keep do
      {:safe, link} =
        temple(do: unquote(block))
        |> PhoenixHTMLHelpers.Link.link(unquote(opts))

      Utils.put_buffer(var!(buff, Temple.Html), link)
    end
  end

  defmacro phx_link(content, opts) do
    quote location: :keep do
      {:safe, link} = PhoenixHTMLHelpers.Link.link(unquote_splicing([content, opts]))

      Utils.put_buffer(var!(buff, Temple.Html), link)
    end
  end

  @doc """
  Please see `PhoenixHTMLHelpers.Link.button/2` for details.
  """
  defmacro phx_button(opts, do: block) do
    quote location: :keep do
      {:safe, link} =
        temple(do: unquote(block))
        |> PhoenixHTMLHelpers.Link.button(unquote(opts))

      Utils.put_buffer(var!(buff, Temple.Html), link)
    end
  end

  defmacro phx_button(content, opts) do
    quote location: :keep do
      {:safe, link} = PhoenixHTMLHelpers.Link.button(unquote_splicing([content, opts]))

      Utils.put_buffer(var!(buff, Temple.Html), link)
    end
  end
end
