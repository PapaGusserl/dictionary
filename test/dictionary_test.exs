defmodule DictionaryTest do
  use ExUnit.Case, async: true
  @moduletag :capture_log
  doctest Dictionary

  describe "Отрицательные проверки." do
    test "var_1" do
        assert DictWorker.trans_of("fggdg") == "fggdg not found!"
    end

    test "var_2" do
        assert DictWorker.trans_of("  ") == "  not found!"
    end
  end

  describe "Положительные проверки." do
    test "var_1" do
        assert DictWorker.trans_of("saw") == "ru:видел"
    end

    test "var_2" do
        assert DictWorker.trans_of("number") == "ru:{количество,число}"
    end
  end
end
