def parse_chart_of_accounts file
  file.
    readlines.
    reject { |line| line.strip.empty? }.
    map do |line|
      [
        line.match(/^\s*/)[0].size,
        line.strip,
      ]
    end.
    reduce([]) do |rubrics, (indent, word)|
      rubrics + [{
        indent: indent,
        words: (rubrics.reverse.find { |rubric| rubric[:indent] < indent } || { words: [] })[:words] + [word]
      }]
    end.
    map { |rubric| rubric[:words].join(":") }.
    each_cons(2).
    reject { |(a, b)| b.start_with?(a + ":") }.
    map(&:first)
end
