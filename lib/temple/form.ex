defmodule Temple.Form do
  @moduledoc """
  This modules wraps all of the functions from the `PhoenixHTMLHelpers.Form` module to make them compatible with with Temple.
  """

  alias PhoenixHTMLHelpers
  alias Temple.Utils

  @doc """
  Generates an empty form tag.

  See `Temple.Form.form_for/4` for more details
  """
  defmacro form_for(form_data, action) do
    quote location: :keep do
      form_for(unquote_splicing([form_data, action]), [])
    end
  end

  @doc """
  Generates a form tag with a form builder and a block.

  The form builder will be available inside the block through the `form` variable.

  This is a wrapper around the `PhoenixHTMLHelpers.Form.form_for/4` function and accepts all of the same options.

  ## Example

  ```
  temple do
    form_for @conn, Routes.some_path(@conn, :create) do
      text_input form, :name
    end
  end

  # {:safe,
  #   "<form accept-charset=\"UTF-8\" action=\"/\" method=\"post\">
  #      <input name=\"_csrf_token\" type=\"hidden\" value=\"AS5qfX1gcns6eU56BlQgBlwCDgMlNgAAiJ0MR91Kh3v3bbCS5SKjuw==\">
  #      <input name=\"_utf8\" type=\"hidden\" value=\"✓\">
  #      <input id=\"name\" name=\"name\" type=\"text\">
  #    </form>"}
  ```
  """
  defmacro form_for(form_data, action, opts \\ [], block) do
    quote location: :keep do
      var!(form) = Phoenix.HTML.FormData.to_form(unquote_splicing([form_data, opts]))

      Utils.put_buffer(var!(buff, Temple.Html), Map.put(var!(form), :action, unquote(action))  |> form_to_iodata())
      _ = unquote(block)
      Utils.put_buffer(var!(buff, Temple.Html), "</form>")
    end
  end

  def form_to_iodata(%{action: action, options: options}) do
    {:safe, contents} = PhoenixHTMLHelpers.Tag.form_tag(action, options)
    contents
  end

  @helpers [
    :checkbox,
    :color_input,
    :date_input,
    :date_select,
    :datetime_local_input,
    :datetime_select,
    :email_input,
    :file_input,
    :hidden_input,
    :number_input,
    :password_input,
    :range_input,
    :search_input,
    :telephone_input,
    :text_input,
    :time_input,
    :time_select,
    :url_input
  ]

  for helper <- @helpers do
    @doc """
    Please see `PhoenixHTMLHelpers.Form.#{helper}/3` for details.
    """
    defmacro unquote(helper)(form, field, opts \\ []) do
      helper = unquote(helper)

      quote location: :keep do
        {:safe, input} =
          apply(PhoenixHTMLHelpers.Form, unquote(helper), [unquote_splicing([form, field, opts])])

        Utils.put_buffer(var!(buff, Temple.Html), input)
      end
    end
  end

  @doc """
  Please see `PhoenixHTMLHelpers.Form.textarea/3` for details.

  Note: Temple defines this function as `text_area` with an underscore, whereas Phoenix.HTML defines it as `textarea` without an underscore.
  """
  defmacro text_area(form, field, opts \\ []) do
    quote location: :keep do
      {:safe, input} = PhoenixHTMLHelpers.Form.textarea(unquote_splicing([form, field, opts]))

      Utils.put_buffer(var!(buff, Temple.Html), input)
    end
  end

  @doc """
  Please see `PhoenixHTMLHelpers.Form.reset/2` for details.
  """
  defmacro reset(value, opts \\ []) do
    quote location: :keep do
      {:safe, input} = PhoenixHTMLHelpers.Form.reset(unquote_splicing([value, opts]))

      Utils.put_buffer(var!(buff, Temple.Html), input)
    end
  end

  @doc """
  Please see `PhoenixHTMLHelpers.Form.submit/1` for details.
  """
  defmacro submit(do: block) do
    quote location: :keep do
      {:safe, input} = PhoenixHTMLHelpers.Form.submit(do: temple(do: unquote(block)))

      Utils.put_buffer(var!(buff, Temple.Html), input)
    end
  end

  defmacro submit(value) do
    quote location: :keep do
      {:safe, input} = PhoenixHTMLHelpers.Form.submit(unquote(value))

      Utils.put_buffer(var!(buff, Temple.Html), input)
    end
  end

  @doc """
  Please see `PhoenixHTMLHelpers.Form.submit/1` for details.
  """
  defmacro submit(opts, do: block) do
    quote location: :keep do
      {:safe, input} =
        PhoenixHTMLHelpers.Form.submit(unquote(opts), do: temple(do: unquote(block)))

      Utils.put_buffer(var!(buff, Temple.Html), input)
    end
  end

  defmacro submit(value, opts) do
    quote location: :keep do
      {:safe, input} = PhoenixHTMLHelpers.Form.submit(unquote_splicing([value, opts]))

      Utils.put_buffer(var!(buff, Temple.Html), input)
    end
  end

  @doc """
  Please see `PhoenixHTMLHelpers.Form.label/2` for details.
  """
  defmacro phx_label(form, field) do
    quote location: :keep do
      {:safe, input} = PhoenixHTMLHelpers.Form.label(unquote_splicing([form, field]))

      Utils.put_buffer(var!(buff, Temple.Html), input)
    end
  end

  @doc """
  Please see `PhoenixHTMLHelpers.Form.label/3` for details.
  """
  defmacro phx_label(form, field, do: block) do
    quote location: :keep do
      {:safe, input} =
        PhoenixHTMLHelpers.Form.label(unquote_splicing([form, field]),
          do: temple(do: unquote(block))
        )

      Utils.put_buffer(var!(buff, Temple.Html), input)
    end
  end

  defmacro phx_label(form, field, text_or_opts) do
    quote location: :keep do
      {:safe, input} =
        PhoenixHTMLHelpers.Form.label(unquote_splicing([form, field, text_or_opts]))

      Utils.put_buffer(var!(buff, Temple.Html), input)
    end
  end

  @doc """
  Please see `PhoenixHTMLHelpers.Form.label/4` for details.
  """
  defmacro phx_label(form, field, opts, do: block) do
    quote location: :keep do
      {:safe, input} =
        PhoenixHTMLHelpers.Form.label(unquote_splicing([form, field, opts]),
          do: temple(do: unquote(block))
        )

      Utils.put_buffer(var!(buff, Temple.Html), input)
    end
  end

  defmacro phx_label(form, field, text, opts) do
    quote location: :keep do
      {:safe, input} = PhoenixHTMLHelpers.Form.label(unquote_splicing([form, field, text, opts]))

      Utils.put_buffer(var!(buff, Temple.Html), input)
    end
  end

  @doc """
  Please see `PhoenixHTMLHelpers.Form.radio_button/4` for details.
  """
  defmacro radio_button(form, field, value, attrs \\ []) do
    quote location: :keep do
      {:safe, input} =
        PhoenixHTMLHelpers.Form.radio_button(unquote_splicing([form, field, value, attrs]))

      Utils.put_buffer(var!(buff, Temple.Html), input)
    end
  end

  @doc """
  Please see `PhoenixHTMLHelpers.Form.multiple_select/4` for details.
  """
  defmacro multiple_select(form, field, options, attrs \\ []) do
    quote location: :keep do
      {:safe, input} =
        PhoenixHTMLHelpers.Form.multiple_select(unquote_splicing([form, field, options, attrs]))

      Utils.put_buffer(var!(buff, Temple.Html), input)
    end
  end

  @doc """
  Please see `PhoenixHTMLHelpers.Form.select/4` for details.
  """
  defmacro select(form, field, options, attrs \\ []) do
    quote location: :keep do
      {:safe, input} =
        PhoenixHTMLHelpers.Form.select(unquote_splicing([form, field, options, attrs]))

      Utils.put_buffer(var!(buff, Temple.Html), input)
    end
  end

  @doc """
  Generate a new form builder for the given parameter in form.

  The form builder will be available inside the block through the `inner_form` variable.

  This is a wrapper around the `PhoenixHTMLHelpers.Form.inputs_for/4` function and accepts all of the same options.

  ## Example

  ```
  temple do
    form_for @parent, Routes.some_path(@conn, :create) do
      text_input form, :name

      inputs_for form, :job do
        text_input inner_form, :description
      end

      inputs_for form, :children do
        text_input inner_form, :name
      end
    end
  end

  # {:safe,
  #   "<form accept-charset=\"UTF-8\" action=\"/\" method=\"post\">
  #      <input name=\"_csrf_token\" type=\"hidden\" value=\"AS5qfX1gcns6eU56BlQgBlwCDgMlNgAAiJ0MR91Kh3v3bbCS5SKjuw==\">
  #      <input name=\"_utf8\" type=\"hidden\" value=\"✓\">
  #      <input id=\"name\" name=\"parent[name]\" type=\"text\">
  #
  #      <input id=\"name\" name=\"parent[job][description]\" type=\"text\">
  #
  #      <input id=\"name\" name=\"parent[children][1][name]\" type=\"text\">
  #      <input id=\"name\" name=\"parent[children][2][name]\" type=\"text\">
  #    </form>"}
  ```
  """
  defmacro inputs_for(form, field, options \\ [], do: block) do
    quote location: :keep do
      form = unquote(form)
      field = unquote(field)
      options = unquote(options)

      options =
        form.options
        |> Keyword.take([:multipart])
        |> Keyword.merge(options)

      form.impl.to_form(form.source, form, field, options)
      |> Enum.each(fn form ->
        Enum.map(form.hidden, fn {k, v} ->
          {:safe, hidden_input} = PhoenixHTMLHelpers.Form.hidden_input(form, k, value: v)

          hidden_input
        end)
        |> Enum.each(&Utils.put_buffer(var!(buff, Temple.Html), &1))

        var!(inner_form) = form

        _ = unquote(block)
      end)
    end
  end
end
