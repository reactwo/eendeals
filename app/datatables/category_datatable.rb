class CategoryDatatable < AjaxDatatablesRails::Base

  def view_columns
    @view_columns ||= {
      id: { source: "Category.id", cond: :eq },
      name: { source: 'Category.name', cond: :start_with },
      created_at: { source: 'Category.created_at', cond: false }
    }
  end

  def data
    records.map do |record|
      {
        id: record.id,
        name: record.name,
        created_at: record.created_at.in_time_zone('New Delhi').strftime('%d %b %Y %H:%M')
      }
    end
  end

  private

  def get_raw_records
    Category.all
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
