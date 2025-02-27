module SeasonStat

  def seasons_to_game_teams(team_id)
    team_game_id = 0
    season_games = Hash.new
    all_game_teams.each do |game_id, hash_pair|
      hash_pair.each do |key, game_team_obj|
        if team_id == game_team_obj.team_id
          team_game_id = game_team_obj.game_id
          season_games[all_games[team_game_id].season] ||= []
          season_games[all_games[team_game_id].season] << game_team_obj
        end
      end
    end
    season_games
  end

  def game_results(team_id)
    seasons_to_game_teams(team_id).values.flatten.group_by do |game_team_obj|
      game_team_obj.result
    end
  end

  def best_season(team_id)
    best_season_var = seasons_to_game_teams(team_id).max_by do |season, array_gameteams|
      wins = array_gameteams.count do |game_team_obj|
        game_team_obj.result == "WIN"
      end
      total_games = array_gameteams.count do |game_team_obj|
        game_team_obj
      end
      wins / total_games.to_f
    end
    best_season_var[0]
  end

  def worst_season(team_id)
    worst_season_var = seasons_to_game_teams(team_id).min_by do |season, array_gameteams|
      wins = array_gameteams.count do |game_team_obj|
        game_team_obj.result == "WIN"
      end
      total_games = array_gameteams.count do |game_team_obj|
        game_team_obj
      end
      wins / total_games.to_f
    end
    worst_season_var[0]
  end

  def average_win_percentage(team_id)
    (game_results(team_id)["WIN"].length / seasons_to_game_teams(team_id).values.flatten
    .length.to_f).round(2)
  end

  def most_goals_scored(team_id)
    highest_scoring_game = seasons_to_game_teams(team_id).values.flatten.max_by do |game_team_obj|
      game_team_obj.goals
    end
    highest_scoring_game.goals
  end

  def fewest_goals_scored(team_id)
    lowest_scoring_game = seasons_to_game_teams(team_id).values.flatten.min_by do |game_team_obj|
      game_team_obj.goals
    end
    lowest_scoring_game.goals
  end

  def biggest_team_blowout(team_id)
  return "Error: Team did not win any games" unless game_results(team_id).keys.include?("WIN")
    game_id_wins = game_results(team_id)["WIN"].map {|gt_obj| gt_obj.game_id}
    goal_differences = game_id_wins.map do |game_id|
      (all_games[game_id].away_goals - all_games[game_id].home_goals).abs
    end
    goal_differences.max
  end

  def worst_loss(team_id)
    return "Error: Team did not lose any games" unless game_results(team_id).keys.include?("LOSS")
    game_id_losses = game_results(team_id)["LOSS"].map {|gt_obj| gt_obj.game_id}
    goal_differences = game_id_losses.map do |game_id|
      (all_games[game_id].away_goals - all_games[game_id].home_goals).abs
    end
    goal_differences.max
  end
end
