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

  it '.hero_translations returns a hero translations repository' do
    expect(subject.hero_translations).to be_a(subject::Repositories::HeroTranslationRepository)
  end

  it '.map_translations returns a map translations repository' do
    expect(subject.map_translations).to be_a(subject::Repositories::MapTranslationRepository)
  end
end
