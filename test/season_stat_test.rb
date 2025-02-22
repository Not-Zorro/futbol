require './test_helper'
require 'minitest/pride'
require_relative '../lib/stat_tracker'
require_relative '../lib/team'
require_relative '../lib/game'
require_relative '../lib/game_team'
require_relative '../module/season_stat'
require 'pry'

class SeasonStatTest < Minitest::Test

  def setup
    game_path = './test/test_data/games_sample_2.csv'
    team_path = './test/test_data/teams_sample.csv'
    game_teams_path = './test/test_data/game_teams_sample_2.csv'

    @locations = {
      games: game_path,
      teams: team_path,
      game_teams: game_teams_path
    }
    @stat_tracker = StatTracker.from_csv(@locations)
  end

  def test_seasons_to_game_teams
    assert_instance_of Hash, @stat_tracker.seasons_to_game_teams("3")
    assert_equal ["20122013", "20132014", "20142015"],
      @stat_tracker.seasons_to_game_teams("3").keys
    assert_instance_of Array, @stat_tracker.seasons_to_game_teams("3")["20122013"]
    assert_equal 7, @stat_tracker.seasons_to_game_teams("3")["20122013"].length
    assert_instance_of GameTeam, @stat_tracker.seasons_to_game_teams("3")["20122013"][0]
    assert_equal "2012030131", @stat_tracker.seasons_to_game_teams("3")["20122013"][0].game_id
    assert_equal "John Tortorella", @stat_tracker.seasons_to_game_teams("3")["20122013"][0].head_coach
  end

  def test_game_results
    assert_instance_of Hash, @stat_tracker.game_results("4")
    assert_equal (["WIN", "LOSS"]), @stat_tracker.game_results("4").keys
    assert_instance_of Array, @stat_tracker.game_results("4")["WIN"]
    assert_equal 1, @stat_tracker.game_results("4")["WIN"].length
    assert_instance_of GameTeam, @stat_tracker.game_results("4")["WIN"][0]
    assert_equal 8, @stat_tracker.game_results("4")["WIN"][0].takeaways
  end

  def test_best_season
    assert_equal "20162017", @stat_tracker.best_season("24")
  end

  def test_worst_season
    assert_equal "20122013", @stat_tracker.worst_season("24")
  end

  def test_average_win_per
    assert_equal 1.0, @stat_tracker.average_win_percentage("6")
  end

  def test_most_goals_scored
    assert_equal 3, @stat_tracker.most_goals_scored("16")
  end

  def test_fewest_goals_scored
    assert_equal 0, @stat_tracker.fewest_goals_scored("3")
  end

  def test_biggest_team_blowout
    assert_equal 499, @stat_tracker.biggest_team_blowout("6")
  end

  def test_worst_loss
    assert_equal 499, @stat_tracker.worst_loss("5")
  end
end
