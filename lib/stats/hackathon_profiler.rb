module HacktivityStats
  class HackathonProfiler
    def initialize(hackathon)
      @hackathon = hackathon
    end

    def get_stats
      repository_profilers = @hackathon.repositories.map{ |r| RepositoryProfiler.new(r) }
      return {} if repository_profilers.empty?

      hack_stats = {
        timed_stats: {},
        total_participants: 0
      }

      # Totals
      repository_profilers.each do |rp|
        rstats = rp.get_stats
        hack_stats[:total_participants] += rstats[:participant_count]
        rstats[:timed_stats].each do |timestamp, tstats|
          timed_stats = rstats[:timed_stats]
          hack_stats[:timed_stats][timestamp] ||= Hash.new(0)
          hack_stats[:timed_stats][timestamp][:total_commits] += tstats[:commits]
          hack_stats[:timed_stats][timestamp][:average_message_length] += tstats[:average_message_length]
          hack_stats[:timed_stats][timestamp][:total_swearword_count] += tstats[:swearword_count][:total]
        end
      end

      # Averages
      hack_stats[:timed_stats].each do |timestamp, stats|
        stats[:average_commits] = stats[:total_commits] / repository_profilers.size
        stats[:average_swearword_count] = stats[:total_swearword_count] / repository_profilers.size
      end
      hack_stats[:average_team_size] = hack_stats[:total_participants] / repository_profilers.size

      return hack_stats
    end
  end
end
