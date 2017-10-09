require 'spec_helper'

RSpec.describe HotsApi do
  it 'has a version number' do
    expect(subject::VERSION).not_to be_nil
  end

  it '.fetcher returns a fetcher' do
    expect(subject.fetcher).to be_a(subject::Fetcher)
  end

  it '.get delegates to the fetcher' do
    expect(subject.fetcher).to receive('get').with('some-path', params: {some_param: 'value'})
    subject.get('some-path', params: {some_param: 'value'})
  end

  it '.post delegates to the fetcher' do
    expect(subject.fetcher).to receive('post').with('some-path', body: 'some-body', file: '/some/file')
    subject.post('some-path', body: 'some-body', file: '/some/file')
  end

  it '.replays returns a replay repository' do
    expect(subject.replays).to be_a(subject::Repositories::ReplayRepository)
  end

  it '.heroes returns a hero repository' do
    expect(subject.heroes).to be_a(subject::Repositories::HeroRepository)
  end

  it '.maps returns a map repository' do
    expect(subject.maps).to be_a(subject::Repositories::MapRepository)
  end
end
