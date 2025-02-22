require './test_helper'
require 'minitest/pride'
require_relative '../lib/stat_tracker'
require_relative '../lib/team'
require_relative '../lib/game'
require_relative '../module/team_stat'
require 'pry'

class TeamStatTest < Minitest::Test

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

  def test_team_info
    expected = {"team_id"=>"6",
                "franchise_id"=>"6",
                "team_name"=>"FC Dallas",
                "abbreviation"=>"DAL",
                "link"=>"/api/v1/teams/6"
              }
    assert_equal expected, @stat_tracker.team_info("6")
  end
end
