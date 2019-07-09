class ConversionDatatable < AjaxDatatablesRails::Base

  def view_columns
    # Declare strings in this format: ModelName.column_name
    # or in aliased_join_table.column_name format
    @view_columns ||= {
      id: { source: 'Conversion.id', cond: :eq },
      transaction_id: { source: 'Conversion.transaction_id', cond: false },
      company: { source: 'Conversion.company', cond: false },
      offer_id: { source: 'Conversion.offer_id', cond: :eq },
      deal_id: { source: 'Conversion.deal_id', cond: :eq },
      user_id: { source: 'Conversion.user_id', cond: false },
      status: { source: 'Conversion.status', cond: false },
      created_at: { source: 'Conversion.created_at', cond: false }
    }
  end

  def data
    records.map do |record|
      {
        id: record.id,
        transaction_id: record.transaction_id,
        company: record.company,
        offer_id: record.offer_id,
        offer_name: record.offer ? record.offer.name : '',
        deal_id: record.deal_id,
        deal_name: record.deal ? record.deal.name : '',
        user_id: record.user_id,
        user_name: record.user.name,
        status: Conversion::STATUS_REVERSE[record.status],
        created_at: record.created_at.in_time_zone('New Delhi').strftime('%d %b %Y %H:%M')
      }
    end
  end

  private

  def get_raw_records
    Conversion.all
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
