$:.unshift File.dirname(__FILE__)
$:.unshift File.dirname(__FILE__) + '/../../modules'
$:.unshift File.dirname(__FILE__) + '/../struct_classes'
require 'base_object'
require 'yaml_interaction'
require 'suppressed_page_rules'
class Page < BaseObject
  include YAMLInteraction
  attr_accessor(:page, :url, :image, :rows, :values, :page_suppressed_rules, :app, :score)

  def access_spr(df_yaml_loc = "./data/suppressed_rules.yaml")
    yaml = read_yaml(df_yaml_loc, app.application_name)
    output = []
    levels = ["GLOBAL", "APP", page.upcase.tr(' ', '_')]
    yaml.each do |key, value|
      if levels.include?(key)
        value.each do |value|
          hash = eval(value)
          output.push(SuppressedPageRules.new(hash[:guideline], hash[:content]))
        end

      end
    end
    set_value("page_suppressed_rules", output)
    page_suppressed_rules
  end

  def remove_suppressed_rows
    page_suppressed_rules.each do |rule|
      rows.delete_if do |row|
        include_content?(row, rule)
      end
    end
  end

  def remove_duplicates(app)
    remove_duplicate_rows_external(app, self)
    remove_duplicate_rows_internal
  end

  def remove_duplicate_rows_external(app, page)
    app.pages.each do |app_page|
      unless (app_page == page)
        app_page.rows.each do |app_row|
          page.rows.delete_if do |row|
            same = same_content?(app_row, row)
            if same
              app_row.send("instances=", app_row.instances.to_i + 1)
            end
          end
        end
      end
    end
  end

  def remove_duplicate_rows_internal
    duplicate_rows = rows.clone.keep_if do |row_a|
      rows.each do |row_b|
        if row_a == row_b
          @same = false
        else
          @same = same_content?(row_b, row_a)
          if @same
            row_a.send("instances=", row_b.instances.to_f + 0.5)
            row_b.send("instances=", row_a.instances.to_f + 0.5)
          end
        end
      end
      @same
    end
    duplicate_rows.each do |duplicate_row|
      rows.delete_if do |row|
        duplicate_row == row
      end
    end
    duplicate_rows
  end

  def calc_page_score
    page_score = 0
    rows.each do |row|
      page_score += row.score
    end
    page_score
  end

  private

  def include_content?(base, comparison)
    base.guideline.include?(comparison.guideline) && base.content.include?(comparison.content)
  end

  def same_content?(base, comparison)
    base.guideline == comparison.guideline && base.content == comparison.content
  end
end



