require_relative 'shared_network_manager_context'

shared_examples :shared_examples_for_ems_network_controller do |providers|
  render_views

  providers.each do |t|
    context "for #{t}" do
      include_context :shared_network_manager_context, t
      before do
        stub_user(:features => :all)
        setup_zone
      end

      describe "#show_list" do
        it "renders index" do
          get :index
          expect(response.status).to eq(302)
          expect(response).to redirect_to(:action => 'show_list')
        end

        it "renders show_list" do
          # TODO(lsmola) figure out why I have to mock pdf available here, but not in other Manager's lists
          allow(PdfGenerator).to receive_messages(:available? => false)
          session[:settings] = {:default_search => 'foo',
                                :views          => {},
                                :perpage        => {:list => 10}}
          get :show_list
          expect(response.status).to eq(200)
          expect(response.body).to_not be_empty
        end
      end

      describe "#show" do
        it "renders show screen" do
          get :show, :params => {:id => @ems.id}
          expect(response.status).to eq(200)
          expect(response.body).to_not be_empty
          expect(assigns(:breadcrumbs)).to eq([{:name => "Network Managers",
                                                :url  => "/ems_network/show_list?page=&refresh=y"},
                                               {:name => "Cloud Manager Network Manager (Summary)",
                                                :url  => "/ems_network/#{@ems.id}"}])
        end

        it "show associated cloud_networks" do
          assert_nested_list(@ems, [@cloud_network], 'cloud_networks', 'All Cloud Networks')
        end

        it "show associated cloud_subnets" do
          assert_nested_list(@ems, [@cloud_subnet], 'cloud_subnets', 'All Cloud Subnets')
        end

        it "show associated network routers" do
          assert_nested_list(@ems, [@network_router], 'network_routers', 'All Network Routers')
        end

        it "show associated security_groups" do
          assert_nested_list(@ems, [@security_group], 'security_groups', 'All Security Groups')
        end

        it "show associated security_policies" do
          assert_nested_list(@ems, [@security_policy], 'security_policies', 'All Security Policies')
        end

        it "show associated floating_ips" do
          assert_nested_list(@ems, [@floating_ip], 'floating_ips', 'All Floating IPs')
        end

        it "show associated network_ports" do
          assert_nested_list(@ems, [@network_port], 'network_ports', 'All Network Ports')
        end

        it "show associated network_services" do
          assert_nested_list(@ems, [@network_service], 'network_services', 'All Network Services')
        end
      end

      describe "#test_toolbars" do
        it "refresh relationships and power states" do
          post :button, :params => {:id => @ems.id, :pressed => "ems_network_refresh"}
          expect(response.status).to eq(200)
        end

        it 'edit selected network provider' do
          post :button, :params => {:miq_grid_checks => @ems.id, :pressed => "ems_network_edit"}
          expect(response.status).to eq(200)
        end

        it 'edit network provider tags' do
          post :button, :params => {:miq_grid_checks => @ems.id, :pressed => "ems_network_tag"}
          expect(response.status).to eq(200)
        end

        it 'manage network provider policies' do
          allow(controller).to receive(:protect_build_tree).and_return(nil)
          controller.instance_variable_set(:@protect_tree, OpenStruct.new(:name => "name", :locals_for_render => {}))

          post :button, :params => {:miq_grid_checks => @ems.id, :pressed => "ems_network_protect"}
          expect(response.status).to eq(200)

          get :protect
          expect(response.status).to eq(200)
          expect(response).to render_template('shared/views/protect')
        end

        it 'edit network provider timeline' do
          get :show, :params => {:display => "timeline", :id => @ems.id}
          expect(response.status).to eq(200)
        end

        it 'edit network providers' do
          post :button, :params => {:miq_grid_checks => @ems.id, :pressed => "ems_network_edit"}
          expect(response.status).to eq(200)
        end
      end
    end
  end
end
