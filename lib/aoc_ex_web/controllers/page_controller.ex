defmodule AocExWeb.PageController do
  use AocExWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
