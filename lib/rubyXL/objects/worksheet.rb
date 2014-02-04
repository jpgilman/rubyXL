require 'rubyXL/objects/ooxml_object'
require 'rubyXL/objects/extensions'
require 'rubyXL/objects/text'
require 'rubyXL/objects/formula'
require 'rubyXL/objects/sheet_view'
require 'rubyXL/objects/sheet_data'
require 'rubyXL/objects/data_validation'

module RubyXL

  # Eventually, the entire code for Worksheet will be moved here. One small step at a time!

  # http://www.schemacentral.com/sc/ooxml/e-ssml_outlinePr-1.html
  class OutlineProperties < OOXMLObject
    define_attribute(:applyStyles,        :bool, :default => false)
    define_attribute(:summaryBelow,       :bool, :default => true)
    define_attribute(:summaryRight,       :bool, :default => true)
    define_attribute(:showOutlineSymbols, :bool, :default => true)
    define_element_name 'outlinePr'
  end

  # http://www.schemacentral.com/sc/ooxml/e-ssml_pageSetUpPr-1.html
  class PageSetupProperties < OOXMLObject
    define_attribute(:autoPageBreaks, :bool, :default => true)
    define_attribute(:fitToPage,      :bool, :default => false)
    define_element_name 'pageSetUpPr'
  end

  # http://www.schemacentral.com/sc/ooxml/e-ssml_sheetPr-3.html
  class WorksheetProperties < OOXMLObject
    define_attribute(:syncHorizontal,                    :bool, :default => false)
    define_attribute(:syncVertical,                      :bool, :default => false)
    define_attribute(:syncRef,                           :ref)
    define_attribute(:transitionEvaluation,              :bool, :default => false)
    define_attribute(:transitionEntry,                   :bool, :default => false)
    define_attribute(:published,                         :bool, :default => true)
    define_attribute(:codeName,                          :string)
    define_attribute(:filterMode,                        :bool, :default => false)
    define_attribute(:enableFormatConditionsCalculation, :bool, :default => true)
    define_child_node(RubyXL::Color, :node_name => :tabColor)
    define_child_node(RubyXL::OutlineProperties)
    define_child_node(RubyXL::PageSetupProperties)
    define_element_name 'sheetPr'
  end

  # http://www.schemacentral.com/sc/ooxml/e-ssml_dimension-3.html
  class WorksheetDimensions < OOXMLObject
    define_attribute(:ref, :ref)
    define_element_name 'dimension'
  end

  class WorksheetFormatProperties < OOXMLObject
    define_attribute(:baseColWidth,     :int,   :default => 8)
    define_attribute(:defaultColWidth,  :float)
    define_attribute(:defaultRowHeight, :float, :required => true)
    define_attribute(:customHeight,     :bool,  :default => false)
    define_attribute(:zeroHeight,       :bool,  :default => false)
    define_attribute(:thickTop,         :bool,  :default => false)
    define_attribute(:thickBottom,      :bool,  :default => false)
    define_attribute(:outlineLevelRow,  :int,   :default => 0)
    define_attribute(:outlineLevelCol,  :int,   :default => 0)
    define_element_name 'sheetFormatPr'
  end

  # http://www.schemacentral.com/sc/ooxml/e-ssml_pageMargins-1.html
  class PageMargins < OOXMLObject
    define_attribute(:left,   :float, :required => true)
    define_attribute(:right,  :float, :required => true)
    define_attribute(:top,    :float, :required => true)
    define_attribute(:bottom, :float, :required => true)
    define_attribute(:header, :float, :required => true)
    define_attribute(:footer, :float, :required => true)
    define_element_name 'pageMargins'
  end

  # http://www.schemacentral.com/sc/ooxml/e-ssml_pageSetup-1.html
  class PageSetup < OOXMLObject
    define_attribute(:paperSize,          :int,    :default => 1)
    define_attribute(:scale,              :int,    :default => 100)
    define_attribute(:firstPageNumber,    :int,    :default => 1)
    define_attribute(:fitToWidth,         :int,    :default => 1)
    define_attribute(:fitToHeight,        :int,    :default => 1)
    define_attribute(:pageOrder,          :string, :default => 'downThenOver',
                       :values => %w{ downThenOver overThenDown })
    define_attribute(:orientation,        :string, :default => 'default',
                       :values => %w{ default portrait landscape })
    define_attribute(:usePrinterDefaults, :bool,   :default => true)
    define_attribute(:blackAndWhite,      :bool,   :default => false)
    define_attribute(:draft,              :bool,   :default => false)
    define_attribute(:cellComments,       :string, :default => 'none',
                       :values => %w{ none asDisplayed atEnd })
    define_attribute(:useFirstPageNumber, :bool,   :default => false)
    define_attribute(:errors,             :string, :default => 'displayed',
                       :values => %w{ displayed blank dash NA })
    define_attribute(:horizontalDpi,      :int,    :default => 600)
    define_attribute(:verticalDpi,        :int,    :default => 600)
    define_attribute(:copies,             :int,    :default => 1)

    define_attribute(:'r:id',             :string)
    define_element_name 'pageSetup'
  end

  class RID < OOXMLObject
    define_attribute(:'r:id',            :string, :required => true)
  end

  class TableParts < OOXMLObject
    define_child_node(RubyXL::RID, :collection => :with_count, :node_name => :table_part)
    define_element_name 'tableParts'
  end

  # http://www.schemacentral.com/sc/ooxml/e-ssml_mergeCell-1.html
  class MergedCell < OOXMLObject
    define_attribute(:ref, :ref)
    define_element_name 'mergeCell'
  end

  # http://www.schemacentral.com/sc/ooxml/e-ssml_mergeCells-1.html
  class MergedCells < OOXMLObject
    define_child_node(RubyXL::MergedCell, :collection => :with_count)
    define_element_name 'mergeCells'
  end

  # http://www.schemacentral.com/sc/ooxml/e-ssml_printOptions-1.html
  class PrintOptions < OOXMLObject
    define_attribute(:horizontalCentered, :bool, :default => false)
    define_attribute(:verticalCentered,   :bool, :default => false)
    define_attribute(:headings,           :bool, :default => false)
    define_attribute(:gridLines,          :bool, :default => false)
    define_attribute(:gridLinesSet,       :bool, :default => true)
    define_element_name 'printOptions'
  end

  # http://www.schemacentral.com/sc/ooxml/e-ssml_headerFooter-1.html
  class HeaderFooterSettings < OOXMLObject
    define_attribute(:differentOddEven, :bool, :default => false)
    define_attribute(:differentFirst,   :bool, :default => false)
    define_attribute(:scaleWithDoc,     :bool, :default => true)
    define_attribute(:alignWithMargins, :bool, :default => true)
    define_child_node(RubyXL::StringValue, :node_name => :oddHeader)
    define_child_node(RubyXL::StringValue, :node_name => :oddFooter)
    define_child_node(RubyXL::StringValue, :node_name => :evenHeader)
    define_child_node(RubyXL::StringValue, :node_name => :evenFooter)
    define_child_node(RubyXL::StringValue, :node_name => :firstHeader)
    define_child_node(RubyXL::StringValue, :node_name => :firstFooter)
    define_element_name 'headerFooter'
  end

  # http://www.schemacentral.com/sc/ooxml/e-ssml_sheetCalcPr-1.html
  class SheetCalculationProperties < OOXMLObject
    define_attribute(:fullCalcOnLoad, :bool, :default => false)
    define_element_name 'sheetCalcPr'
  end

  # http://www.schemacentral.com/sc/ooxml/e-ssml_protectedRange-1.html
  class ProtectedRange < OOXMLObject
    define_attribute(:password,           :string)
    define_attribute(:sqref,              :sqref, :required => true)
    define_attribute(:name,               :string, :required => true)
    define_attribute(:securityDescriptor, :string)
    define_element_name 'protectedRange'
  end

  # http://www.schemacentral.com/sc/ooxml/e-ssml_protectedRanges-1.html
  class ProtectedRanges < OOXMLObject
    define_child_node(RubyXL::ProtectedRange, :collection => true)
    define_element_name 'protectedRanges'
  end

  # http://www.schemacentral.com/sc/ooxml/e-ssml_sheetProtection-1.html
  class SheetProtection < OOXMLObject
    define_attribute(:password,            :string)
    define_attribute(:sheet,               :bool, :default => false)
    define_attribute(:objects,             :bool, :default => false)
    define_attribute(:scenarios,           :bool, :default => false)
    define_attribute(:formatCells,         :bool, :default => true)
    define_attribute(:formatColumns,       :bool, :default => true)
    define_attribute(:formatRows,          :bool, :default => true)
    define_attribute(:insertColumns,       :bool, :default => true)
    define_attribute(:insertRows,          :bool, :default => true)
    define_attribute(:insertHyperlinks,    :bool, :default => true)
    define_attribute(:deleteColumns,       :bool, :default => true)
    define_attribute(:deleteRows,          :bool, :default => true)
    define_attribute(:selectLockedCells,   :bool, :default => false)
    define_attribute(:sort,                :bool, :default => true)
    define_attribute(:autoFilter,          :bool, :default => true)
    define_attribute(:pivotTables,         :bool, :default => true)
    define_attribute(:selectUnlockedCells, :bool, :default => false)
    define_element_name 'sheetProtection'
  end

  # http://www.schemacentral.com/sc/ooxml/e-ssml_cfvo-1.html
  class ConditionalFormatValue < OOXMLObject
    define_attribute(:type, :string, :required => true, :values =>
                       %w{ num percent max min formula percentile })
    define_attribute(:val,  :string)
    define_attribute(:gte,  :bool,   :default => true)
    define_child_node(RubyXL::ExtensionStorageArea)
    define_element_name 'cfvo'
  end

  # http://www.schemacentral.com/sc/ooxml/e-ssml_colorScale-1.html
  class ColorScale < OOXMLObject
    define_child_node(RubyXL::ConditionalFormatValue, :collection => true, :accessor => :cfvo)
    define_child_node(RubyXL::Color)
    define_element_name 'colorScale'
  end

  # http://www.schemacentral.com/sc/ooxml/e-ssml_dataBar-1.html
  class DataBar < OOXMLObject
    define_attribute(:minLength, :int,  :default => 10)
    define_attribute(:maxLength, :int,  :default => 90)
    define_attribute(:showValue, :bool, :default => true)
    define_child_node(RubyXL::ConditionalFormatValue, :collection => true, :accessor => :cfvo)
    define_child_node(RubyXL::Color)
    define_element_name 'dataBar'
  end

  # http://www.schemacentral.com/sc/ooxml/e-ssml_iconSet-1.html
  class IconSet < OOXMLObject
    define_attribute(:type,      :string, :required => true, :default => '3TrafficLights1', :values =>
                       %w{ 3Arrows 3ArrowsGray 3Flags 3TrafficLights1 3TrafficLights2
                           3Signs 3Symbols 3Symbols2 4Arrows 4ArrowsGray 4RedToBlack
                           4Rating 4TrafficLights 5Arrows 5ArrowsGray 5Rating 5Quarters })
    define_attribute(:showValue, :bool,   :default => true)
    define_attribute(:percent,   :bool,   :default => true)
    define_attribute(:reverse,   :bool,   :default => false)
    define_child_node(RubyXL::ConditionalFormatValue, :collection => true, :accessor => :cfvo)
    define_element_name 'iconSet'
  end

  # http://www.schemacentral.com/sc/ooxml/e-ssml_cfRule-1.html
  class ConditionalFormattingRule < OOXMLObject
    define_attribute(:type,         :string, :values =>
                       %w{ expression cellIs colorScale dataBar iconSet top10 uniqueValues
                           duplicateValues containsText notContainsText beginsWith
                           endsWith containsBlanks notContainsBlanks containsErrors
                           notContainsErrors timePeriod aboveAverage })
    define_attribute(:dxfId,        :int)
    define_attribute(:priority,     :int,    :required => 1)
    define_attribute(:stopIfTrue,   :bool,   :default  => false)
    define_attribute(:aboveAverage, :bool,   :default  => true)
    define_attribute(:percent,      :bool,   :default  => false)
    define_attribute(:bottom,       :bool,   :default  => false)
    define_attribute(:operator,     :string, :values =>
                       %w{ lessThan lessThanOrEqual equal notEqual greaterThanOrEqual greaterThan
                           between notBetween containsText notContains beginsWith endsWith })
    define_attribute(:text,         :string)
    define_attribute(:timePeriod,   :string, :values =>
                       %w{ today yesterday tomorrow last7Days thisMonth
                           lastMonth nextMonth thisWeek lastWeek nextWeek })
    define_attribute(:rank,         :int)
    define_attribute(:stdDev,       :int)
    define_attribute(:equalAverage, :bool,   :default  => false)
    define_child_node(RubyXL::Formula, :collection => true, :node_name => :formula, :accessor => :formulas)
    define_child_node(RubyXL::ColorScale)
    define_child_node(RubyXL::DataBar)
    define_child_node(RubyXL::IconSet)
    define_child_node(RubyXL::ExtensionStorageArea)
    define_element_name 'cfRule'
  end

  # http://www.schemacentral.com/sc/ooxml/e-ssml_brk-1.html
  class Break < OOXMLObject
    define_attribute(:id,  :int,  :default => 0)
    define_attribute(:min, :int,  :default => 0)
    define_attribute(:max, :int,  :default => 0)
    define_attribute(:man, :bool, :default => false)
    define_attribute(:pt,  :bool, :default => false)
    define_element_name 'brk'
  end

  # http://www.schemacentral.com/sc/ooxml/e-ssml_rowBreaks-1.html
  class BreakList < OOXMLObject
    define_attribute(:manualBreakCount, :int, :default => 0)
    define_child_node(RubyXL::Break, :collection => :with_count)
  end

  # http://www.schemacentral.com/sc/ooxml/e-ssml_conditionalFormatting-1.html
  class ConditionalFormatting < OOXMLObject
    define_attribute(:pivot, :bool, :default => false)
    define_attribute(:sqref, :sqref)
    define_child_node(RubyXL::ConditionalFormattingRule, :collection => true, :accessor => :cf_rules)
    define_child_node(RubyXL::ExtensionStorageArea)
    define_element_name 'conditionalFormatting'
  end

  # http://www.schemacentral.com/sc/ooxml/e-ssml_inputCells-1.html
  class InputCells < OOXMLObject
    define_attribute(:r,        :ref,    :required => true)
    define_attribute(:deleted,  :bool,   :default => false)
    define_attribute(:undone,   :bool,   :default => false)
    define_attribute(:val,      :string, :required => true)
    define_attribute(:numFmtId, :int)
    define_element_name 'inputCells'
  end

  # http://www.schemacentral.com/sc/ooxml/e-ssml_scenario-1.html
  class Scenario < OOXMLObject
    define_attribute(:name,    :string)
    define_attribute(:locked,  :bool, :default => false)
    define_attribute(:hidden,  :bool, :default => false)
    define_attribute(:user,    :string)
    define_attribute(:comment, :string)
    define_child_node(RubyXL::InputCells, :collection => :with_count)
    define_element_name 'scenario'
  end

  # http://www.schemacentral.com/sc/ooxml/e-ssml_scenarios-1.html
  class ScenarioContainer < OOXMLObject
    define_attribute(:current, :int)
    define_attribute(:show,    :int)
    define_attribute(:sqref,   :sqref)
    define_child_node(RubyXL::Scenario, :collection => true, :accessor => :scenarios)
    define_element_name 'scenarios'
  end

  # http://www.schemacentral.com/sc/ooxml/e-ssml_ignoredError-1.html
  class IgnoredError < OOXMLObject
    define_attribute(:sqref,              :sqref, :required => true)
    define_attribute(:pivot,              :bool,  :default  => false)
    define_attribute(:evalError,          :bool,  :default  => false)
    define_attribute(:twoDigitTextYear,   :bool,  :default  => false)
    define_attribute(:numberStoredAsText, :bool,  :default  => false)
    define_attribute(:formula,            :bool,  :default  => false)
    define_attribute(:formulaRange,       :bool,  :default  => false)
    define_attribute(:unlockedFormula,    :bool,  :default  => false)
    define_attribute(:emptyCellReference, :bool,  :default  => false)
    define_attribute(:listDataValidation, :bool,  :default  => false)
    define_attribute(:calculatedColumn,   :bool,  :default  => false)
    define_element_name 'ignoredError'
  end

  # http://www.schemacentral.com/sc/ooxml/e-ssml_ignoredErrors-1.html
  class IgnoredErrorContainer < OOXMLObject
    define_child_node(RubyXL::IgnoredError, :collection => true, :accessor => :scenarios)
    define_child_node(RubyXL::ExtensionStorageArea)
    define_element_name 'ignoredErrors'
  end

  # http://www.schemacentral.com/sc/ooxml/e-ssml_sortCondition-1.html
  class SortCondition < OOXMLObject
    define_attribute(:descending, :bool,   :default  => false)
    define_attribute(:sortBy,     :string, :default => 'value',
                       :values => %w{ value cellColor fontColor icon })
    define_attribute(:ref,        :ref,    :required => true)
    define_attribute(:customList, :string)
    define_attribute(:dxfId,      :int)
    define_attribute(:iconSet,    :string, :required => true, :default => '3Arrows', :values =>
                       %w{ 3Arrows 3ArrowsGray 3Flags 3TrafficLights1 3TrafficLights2
                           3Signs 3Symbols 3Symbols2 4Arrows 4ArrowsGray 4RedToBlack
                           4Rating 4TrafficLights 5Arrows 5ArrowsGray 5Rating 5Quarters })
    define_attribute(:iconId,     :int)
    define_element_name 'sortCondition'
  end

  # http://www.schemacentral.com/sc/ooxml/e-ssml_sortState-2.html
  class SortState < OOXMLObject
    define_attribute(:columnSort,    :bool,   :default  => false)
    define_attribute(:caseSensitive, :bool,   :default  => false)
    define_attribute(:sortMethod,    :string, :default => 'none',
                       :values => %w{ stroke pinYin none })
    define_attribute(:ref,           :ref,    :required => true)
    define_child_node(RubyXL::SortCondition,  :colection => true)
    define_child_node(RubyXL::ExtensionStorageArea)
    define_element_name 'sortState'
  end

  # http://www.schemacentral.com/sc/ooxml/e-ssml_hyperlink-1.html
  class Hyperlink < OOXMLObject
    define_attribute(:ref,      :ref,    :required => true)
    define_attribute(:'r:id',   :string)
    define_attribute(:location, :string)
    define_attribute(:tooltip,  :string)
    define_attribute(:display,  :string)
    define_element_name 'hyperlink'
  end

  # http://www.schemacentral.com/sc/ooxml/e-ssml_hyperlinks-1.html
  class HyperlinkContainer < OOXMLObject
    define_child_node(RubyXL::Hyperlink, :colection => true, :accessor => :hyperlinks)
    define_element_name 'hyperlinks'
  end

  # http://www.schemacentral.com/sc/ooxml/s-sml-sheet.xsd.html
  class Worksheet < OOXMLObject
    define_child_node(RubyXL::WorksheetProperties)
    define_child_node(RubyXL::WorksheetDimensions)
    define_child_node(RubyXL::SheetViews)
    define_child_node(RubyXL::WorksheetFormatProperties)
    define_child_node(RubyXL::ColumnRanges)
    define_child_node(RubyXL::SheetData)
    define_child_node(RubyXL::SheetCalculationProperties)
    define_child_node(RubyXL::SheetProtection)
    define_child_node(RubyXL::ProtectedRanges)
    define_child_node(RubyXL::ScenarioContainer)
#    ssml:autoFilter [0..1]    AutoFilter
    define_child_node(RubyXL::SortState)
#    ssml:dataConsolidate [0..1]    Data Consolidate
#    ssml:customSheetViews [0..1]    Custom Sheet Views
    define_child_node(RubyXL::MergedCells, :accessor => :merged_cells_list)
    define_child_node(RubyXL::PhoneticProperties)
    define_child_node(RubyXL::ConditionalFormatting)
    define_child_node(RubyXL::DataValidations)
    define_child_node(RubyXL::HyperlinkContainer)
    define_child_node(RubyXL::PrintOptions)
    define_child_node(RubyXL::PageMargins)
    define_child_node(RubyXL::PageSetup)
    define_child_node(RubyXL::HeaderFooterSettings)
    define_child_node(RubyXL::BreakList, :node_name => :rowBreaks)
    define_child_node(RubyXL::BreakList, :node_name => :colBreaks)
#    ssml:customProperties [0..1]    Custom Properties
#    ssml:cellWatches [0..1]    Cell Watch Items
    define_child_node(RubyXL::IgnoredErrorContainer)
#    ssml:smartTags [0..1]    Smart Tags
    define_child_node(RubyXL::RID, :node_name => :drawing)
    define_child_node(RubyXL::RID, :node_name => :legacyDrawing)
    define_child_node(RubyXL::RID, :node_name => :legacyDrawingHF)
    define_child_node(RubyXL::RID, :node_name => :picture)
#    ssml:oleObjects [0..1]    OLE Objects
#    ssml:controls [0..1]    Embedded Controls
#    ssml:webPublishItems [0..1]    Web Publishing Items
    define_child_node(RubyXL::TableParts)
    define_child_node(RubyXL::ExtensionStorageArea)
    define_element_name 'worksheet'
    set_namespaces('xmlns'       => 'http://schemas.openxmlformats.org/spreadsheetml/2006/main',
                   'xmlns:r'     => 'http://schemas.openxmlformats.org/officeDocument/2006/relationships',
                   'xmlns:mc'    => 'http://schemas.openxmlformats.org/markup-compatibility/2006',
                   'xmlns:x14ac' => 'http://schemas.microsoft.com/office/spreadsheetml/2009/9/ac',
                   'xmlns:mv'    => 'urn:schemas-microsoft-com:mac:vml')

    def before_write_xml # This method may need to be moved higher in the hierarchy
      first_nonempty_row = nil
      last_nonempty_row = 0
      first_nonempty_column = nil
      last_nonempty_column = 0

      if sheet_data then
        sheet_data.rows.each_with_index { |row, row_index|
          next if row.nil? || row.cells.empty?

          first_nonempty_cell = nil
          last_nonempty_cell = 0

          row.cells.each_with_index { |cell, col_index|
            next if cell.nil?
            cell.r = RubyXL::Reference.new(row_index, col_index)

            first_nonempty_cell ||= col_index
            last_nonempty_cell = col_index
          }

          if first_nonempty_cell then # If there's nothing in this row, then +first_nonempty_cell+ will be +nil+.
            last_nonempty_row = row_index
            first_nonempty_row ||= row_index

            first_nonempty_column ||= first_nonempty_cell
            last_nonempty_column = last_nonempty_cell if last_nonempty_cell > last_nonempty_column
          end

          row.r = row_index + 1
          row.spans = "#{first_nonempty_cell + 1}:#{last_nonempty_cell + 1}"
          row.custom_format = (row.s.to_i != 0)
        }

        if first_nonempty_row then
          self.dimension ||= RubyXL::WorksheetDimensions.new
          self.dimension.ref = RubyXL::Reference.new(first_nonempty_row, last_nonempty_row,
                                                     first_nonempty_column, last_nonempty_column)
        end

      end

      true
    end

    def merged_cells
      (merged_cells_list && merged_cells_list.merge_cell) || []
    end

    include LegacyWorksheet

  end

end