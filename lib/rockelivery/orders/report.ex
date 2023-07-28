defmodule Rockelivery.Orders.Report do
  import Ecto.Query
  alias Rockelivery.{Repo, Item, Order}
  alias Rockelivery.Orders.TotalPrice

  @default_block_size 500

  def create(filename \\ "report.csv") do
    query = from order in Order, order_by: order.user_id

    # 'stream' has to be inside the 'transaction' function and load the query in parts - default is 500 lines
    {:ok, orders_list} =
      Repo.transaction(
        fn ->
          query
          |> Repo.stream(max_rows: @default_block_size)
          |> Stream.chunk_every(@default_block_size)
          |> Stream.flat_map(fn chunk -> Repo.preload(chunk, :items) end)
          |> Enum.into([])
          |> Enum.map(fn order -> parse_line(order) end)
        end,
        timeout: :infinity
      )

    File.write(filename, orders_list)
  end

  defp parse_line(%Order{user_id: user_id, payment_method: payment_method, items: items}) do
    total_price = TotalPrice.calculate(items)
    items_string = Enum.map(items, fn item -> item_string(item) end)
    "#{user_id}, #{payment_method}, #{items_string} #{total_price} \n"
  end

  defp item_string(%Item{category: category, description: description, price: price}) do
    "#{category}, #{description}, #{price},"
  end
end
