require 'neo4j-core'


module PrettyDate
  def time_ago
    a = (Time.now-self).to_i

    case a
      when 0 then 'just now'
      when 1 then 'a second ago'
      when 2..59 then a.to_s+' seconds ago'
      when 60..119 then 'a minute ago' #120 = 2 minutes
      when 120..3540 then (a/60).to_i.to_s+' minutes ago'
      when 3541..7100 then 'an hour ago' # 3600 = 1 hour
      when 7101..82800 then ((a+99)/3600).to_i.to_s+' hours ago'
      when 82801..172000 then 'a day ago' # 86400 = 1 day
      when 172001..518400 then ((a+800)/(60*60*24)).to_i.to_s+' days ago'
      when 518400..1036800 then 'a week ago'
      else ((a+180000)/(60*60*24*7)).to_i.to_s+' weeks ago'
    end
  end
end

Time.send :include, PrettyDate

class SamanthaCore

      def initialize(db_url)
        @db_url = db_url
      end

      WHATS_HAPPENING_QUERY = %{
        MATCH (person:Person)-[r:CREATED]->(thing)-[:HAS_TOPIC]->(topic:Topic)
        RETURN person, r, thing, topic
        ORDER BY r.created_at DESC
        LIMIT 10
      }

      def whats_happening?
        result = run_query(WHATS_HAPPENING_QUERY)
        results = result.to_a

        messages = results.map {|r| message(r) }
        return messages
      end

      def message(result)
        name = result.person.props[:name]
        type_of_thing = result.thing.labels.first
        thing_name = result.thing.props[:title]
        topic = result.topic.props[:title]

        created_at = Time.at(result.r.props[:created_at])
        time_ago = created_at.time_ago
        "#{name} created #{type_of_thing}:'#{thing_name}' with topic '#{topic}' #{time_ago}"
      end

      def run_query(query)
        session.query(query)
      end

      def session
        @neo4j_session ||= Neo4j::Session.open(:server_db, @db_url )
      end
end
