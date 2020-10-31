RSpec.describe TweetsController, type: :request do
  describe 'POST #create' do
    context 'valid params' do
      before(:each) do
        params = ActionController::Parameters.new(q: 'New York')
        params.permit!

        expect(WeatherTweetterService).to(
          receive(:call)
            .with(params)
            .and_return('message')
        )
        post tweets_path, params: { q: 'New York' }
      end

      it { expect(JSON.parse(response.body)['tweet']).to eq('message') }
      it { expect(response).to have_http_status(200) }
    end

    context 'invalid params' do
      before(:each) do
        post tweets_path, params: { invalid: 'New York' }
      end

      it { expect(JSON.parse(response.body)['error']).to be_present }
      it { expect(response).to have_http_status(400) }
    end
  end
end