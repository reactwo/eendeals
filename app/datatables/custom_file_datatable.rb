class CustomFileDatatable < AjaxDatatablesRails::Base

  def view_columns
    # Declare strings in this format: ModelName.column_name
    # or in aliased_join_table.column_name format
    @view_columns ||= {
      id: { source: "CustomFile.id", cond: :eq },
      name: { source: 'CustomFile.name', cond: :start_with },
      file: { source: "CustomFile.file", cond: false },
      created_at: { source: 'CustomFile.created_at', cond: false }
    }
  end

  def data
    records.map do |record|
      {
        # example:
        id: record.id,
        file: "http://139.59.66.125#{record.file.url}",
        name: record.name,
        created_at: record.created_at.in_time_zone('New Delhi').strftime('%d %b %Y %H:%M')
      }
    end
  end

  private

  def get_raw_records
    CustomFile.all
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
