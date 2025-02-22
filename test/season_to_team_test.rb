require './test_helper'
require 'minitest/pride'
require_relative '../lib/stat_tracker'
require_relative '../lib/team'
require_relative '../lib/game'
require_relative '../lib/game_team'
require_relative '../module/season_to_team_stats'
require 'mocha/minitest'
require 'pry'

class SeasonToTeamStatsTest < Minitest::Test
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

  def test_seasonal_info
    expected = {
      "20"=>{
        :postseason=>{
          :game_count=>4,
          :goal_count=>7,
          :shot_count=>34,
          :tackle_count=>123},
        :regular_season=>{}
        },
      "24"=>{
        :postseason=>{
          :game_count=>4,
          :win_count=>4,
          :goal_count=>12,
          :shot_count=>29,
          :tackle_count=>106},
        :regular_season=>{}
        }
    }
    assert_equal expected, @stat_tracker.seasonal_info("20162017")
  end

  def test_biggest_bust
    assert_equal "Toronto FC", @stat_tracker.biggest_bust("20162017")
  end

  def test_biggest_surprise
    assert_equal "Real Salt Lake", @stat_tracker.biggest_surprise("20162017")
  end

  def test_coach_records
    expected = {
      "Glen Gulutzan"=>{:game_count=>4, :win_count=>0},
      "Randy Carlyle"=>{:game_count=>4, :win_count=>4}
    }
    assert_equal expected, @stat_tracker.coach_records("20162017")
  end

  def test_winningest_coach
    assert_equal "Randy Carlyle", @stat_tracker.winningest_coach("20162017")
    assert_equal "Alain Vigneault", @stat_tracker.winningest_coach("20142015")
  end

  def test_worst_coach
    assert_equal "Glen Gulutzan", @stat_tracker.worst_coach("20162017")
    assert_equal "Craig Berube", @stat_tracker.worst_coach("20142015")
  end

  def test_most_accurate_team
    assert_equal "Real Salt Lake", @stat_tracker.most_accurate_team("20162017")
  end

  def test_least_accurate_team
    assert_equal "Toronto FC", @stat_tracker.least_accurate_team("20162017")
  end

  def test_most_tackles
    assert_equal "Toronto FC", @stat_tracker.most_tackles("20162017")
  end

  def test_fewest_tackles
    assert_equal "Real Salt Lake", @stat_tracker.fewest_tackles("20162017")
  end
end
