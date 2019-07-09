class OfferDatatable < AjaxDatatablesRails::Base

  def view_columns
    # Declare strings in this format: ModelName.column_name
    # or in aliased_join_table.column_name format
    @view_columns ||= {
      id: { source: "Offer.id", cond: :eq },
      name: { source: "Offer.name", cond: :like },
      link: { source: "Offer.link", cond: :eq },
      active: { source: "Offer.active", cond: :eq },
      created_at: { source: 'Offer.created_at', cond: false }
    }
  end

  def data
    records.map do |record|
      {
        id: record.id,
        name: record.name,
        link: record.link,
        active: record.active,
        created_at: record.created_at.in_time_zone('New Delhi').strftime('%d %b %Y %H:%M')
      }
    end
  end

  private

  def get_raw_records
    Offer.all
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
