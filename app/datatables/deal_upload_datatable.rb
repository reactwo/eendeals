class DealUploadDatatable < AjaxDatatablesRails::Base

  def view_columns
    # Declare strings in this format: ModelName.column_name
    # or in aliased_join_table.column_name format
    @view_columns ||= {
      id: { source: "DealUpload.id", cond: :eq },
      image: { source: "DealUpload.image", cond: :like },
      status: { source: 'DealUpload.status', cond: false },
      created_at: { source: 'DealUpload.created_at', cond: false }
    }
  end

  def data
    records.map do |record|
      {
        id: record.id,
        image: record.image.url,
        deal: record.deal.name,
        user: record.user.name,
        deal_id: record.deal_id,
        user_id: record.user_id,
        status: record.status,
        created_at: record.created_at.in_time_zone('New Delhi').strftime('%d %b %Y %H:%M')
      }
    end
  end

  private

  def get_raw_records
    DealUpload.all.order(created_at: :desc)
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
