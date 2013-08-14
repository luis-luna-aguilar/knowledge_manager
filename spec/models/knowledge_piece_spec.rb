require 'spec_helper'

describe KnowledgePiece do
  it { should have_and_belong_to_many(:tags) }
  it { should belong_to(:article) }
end