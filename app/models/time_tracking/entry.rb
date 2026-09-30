module TimeTracking
  # Minutes logged on a client, engagement or todo (polymorphic, like notes and documents).
  # The engagement and client are kept alongside so totals roll up.
  class Entry < ::ApplicationRecord
    self.table_name = "time_tracking_entries"

    TRACKABLE_TYPES = %w[Client Engagement Todo].freeze

    belongs_to :user, class_name: "::User"
    belongs_to :trackable, polymorphic: true, optional: true
    belongs_to :engagement, class_name: "::Engagement", optional: true
    belongs_to :client, class_name: "::Client", optional: true

    scope :recent, -> { order(worked_on: :desc, created_at: :desc) }

    validates :trackable_type, inclusion: { in: TRACKABLE_TYPES }, allow_nil: true
    validates :minutes, numericality: { only_integer: true, greater_than: 0 }

    before_validation :fill_in_context
    before_validation { self.worked_on ||= Date.current }

    class << self
      # Everything logged on a record: a client's includes its engagements and work, an
      # engagement's includes its work.
      def for(record)
        case record
        when ::Client then where(client: record)
        when ::Engagement then where(engagement: record)
        else where(trackable: record)
        end
      end

      # Time on a scope item goes to its engagement, on a request to its client.
      def trackable_for(record)
        TRACKABLE_TYPES.include?(record.class.name) ? record : record.try(:engagement) || record.try(:client)
      end

      # "1:30", "90", "1.5h", "1h 30m" or "45m", as minutes.
      def minutes_from(text)
        text = text.to_s.strip.downcase
        case text
        when /\A(\d+):(\d{1,2})\z/ then $1.to_i * 60 + $2.to_i
        when /\A(\d+(?:\.\d+)?)\s*h\z/ then ($1.to_f * 60).round
        when /\A(?:(\d+)\s*h)?\s*(?:(\d+)\s*m)?\z/ then $1.to_i * 60 + $2.to_i
        when /\A\d+\z/ then text.to_i
        end
      end
    end

    def label
      case trackable
      when ::Todo then trackable.title
      when ::Engagement then "#{trackable.ref} #{trackable.title}"
      when ::Client then trackable.name
      else "No record"
      end
    end

    private
      def fill_in_context
        case trackable
        when ::Todo
          self.engagement = trackable.engagement
          self.client_id = trackable.engagement.client_id
        when ::Engagement
          self.engagement = trackable
          self.client_id = trackable.client_id
        when ::Client
          self.engagement = nil
          self.client = trackable
        end
      end
  end
end
