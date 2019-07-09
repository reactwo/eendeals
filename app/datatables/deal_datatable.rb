class DealDatatable < AjaxDatatablesRails::Base

  def view_columns
    # Declare strings in this format: ModelName.column_name
    # or in aliased_join_table.column_name format
    @view_columns ||= {
        id: { source: "Deal.id", cond: :eq },
        name: { source: "Deal.name", cond: :like },
        link: { source: "Deal.link", cond: :eq },
        active: { source: "Deal.active", cond: :eq },
        downloaded: { source: 'Deal.downloaded', cond: :eq },
        cap: { source: 'Deal.cap', cond: :eq },
        created_at: { source: 'Deal.created_at', cond: false }
    }
  end

  def data
    records.map do |record|
      {
          id: record.id,
          name: record.name,
          link: record.link,
          active: record.active,
          downloaded: record.downloaded,
          cap: record.cap,
          created_at: record.created_at.in_time_zone('New Delhi').strftime('%d %b %Y %H:%M')
      }
    end
  end

  private

  def get_raw_records
    Deal.all
  end

  # ==== These methods represent the basic operations to perform on records
  # and feel free to override them

  # def filter_records(records)
  # end

  # def sort_records(records)
  # end

  # def paginate_records(records)
  # end

  # ==== Insert 'presenter'-like methods below if necessary
end
