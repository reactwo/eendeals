class WallpaperDatatable < AjaxDatatablesRails::Base

  def view_columns
    # Declare strings in this format: ModelName.column_name
    # or in aliased_join_table.column_name format
    @view_columns ||= {
      id: { source: "Wallpaper.id", cond: :eq },
      name: { source: "Wallpaper.name", cond: :start_with },
      category: { source: 'Wallpaper.Category.name', cond: false },
      created_at: { source: 'Wallpaper.created_at', cond: false }
    }
  end

  def data
    records.map do |record|
      {
        # example:
        id: record.id,
        name: record.name,
        category_name: record.category.name,
        category_id: record.category_id,
        created_at: record.created_at.in_time_zone('New Delhi').strftime('%d %b %Y %H:%M')
      }
    end
  end

  private

  def get_raw_records
    Wallpaper.all
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
