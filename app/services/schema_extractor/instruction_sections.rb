module SchemaExtractor
  class InstructionSections < Base
    def process
      return unless extracted.present?

      steps = extracted.select { _1["@type"] == "HowToStep" }

      if steps.blank?
        steps = extracted.find { _1.values_at("@type", "name") == ["HowToSection", "Recipe Instructions"] }
          &.dig("itemListElement")
          &.map { { text: _1["text"] } }
      end

      return if steps.blank?

      instructions = steps
        .map { _1.with_indifferent_access.slice(:text, :name) }
        .map { Instruction.new(_1) }

      [InstructionSection.new(name: "Instructions", instructions: instructions)]
    end
  end
end
