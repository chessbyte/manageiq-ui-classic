describe TreeBuilderAutomateSimulationResults do
  context 'TreeBuilderAutomateSimulationResults' do
    before do
      @data = "<MiqAeWorkspace>\\n<MiqAeObject namespace='ManageIQ/SYSTEM' class='PROCESS' instance='Automation'>\\n</MiqAeObject>\\n</MiqAeWorkspace>\\n"
      @ae_simulation_tree = TreeBuilderAutomateSimulationResults.new(:ae_simulation_tree, :ae_simulation, {}, true, @data)
    end

    it 'no root is set' do
      root_options = @ae_simulation_tree.send(:root_options)
      expect(root_options).to eq({})
    end

    it 'sets attribute nodes correctly' do
      nodes = @ae_simulation_tree.send(:x_get_tree_roots, false)
      tree_data = {:id         => "e_1",
                   :text       => "ManageIQ/SYSTEM / PROCESS / Automation",
                   :image      => "100/q.png",
                   :tooltip    => "ManageIQ/SYSTEM / PROCESS / Automation",
                   :elements   => [],
                   :selectable => false}
      expect(nodes).to include(tree_data)
    end
  end
end
