module BetterSet
  RSpec.describe Set do
    describe ".big_union" do
      context "one of the args is not a set" do
        it "raises an argument error" do
          set = Set.new
          other = "hey"

          expect { Set.big_union(set, other) }.to raise_error(
            ArgumentError,
            "Argument must be a BetterSet",
          )
        end
      end

      it "returns the union of all passed in sets" do
        set = Set.new(1)
        set2 = Set.new(1,2)
        set3 = Set.new("a", "b")

        expect(Set.big_union(set, set2, set3)).to eq(
          Set.new(1, 2, "a", "b")
        )
      end
    end

    describe ".big_intersection" do
      context "one of the args is not a set" do
        it "raises an argument error" do
          set = Set.new
          other = "hey"

          expect { Set.big_intersection(set, other) }.to raise_error(
            ArgumentError,
            "Argument must be a BetterSet",
          )
        end
      end

      it "returns the union of all passed in sets" do
        set = Set.new(1)
        set2 = Set.new(1, 2)
        set3 = Set.new("a", "b", 1)

        expect(Set.big_intersection(set, set2, set3)).to eq(
          Set.new(1)
        )
      end
    end

    describe "initialize" do
      context "no arguments" do
        it "initializes an empty set" do
          set = Set.new

          expect(set.instance_variable_get(:@hash)).to eq(Hash.new(false))
        end
      end

      context "array of stuff" do
        it "creates and stores hash out of the array" do
          set = Set.new("justine")

          expect(set.instance_variable_get(:@hash)).to eq(
            "justine" => true,
          )
        end
      end

      context "duplicates" do
        it "does not store duplicates" do
          set = Set.new("justine", "justine", 1, 1)

          expect(set.instance_variable_get(:@hash)).to eq(
            "justine" => true,
            1 => true,
          )
        end

        context "of type set" do
          it "does not store dupes" do
            expect(Set.new(Set.new, Set.new)).to eq(Set.new(Set.new))
          end
        end
      end
    end

    describe "delegations" do
      it { should delegate_method(:all?).to(:to_a) }
      it { should delegate_method(:any?).to(:to_a) }
      it { should delegate_method(:none?).to(:to_a) }
      it { should delegate_method(:reduce).to(:to_a) }
    end

    describe "#add" do
      it "returns a set including the new element" do
        set = Set.new(1)

        expect(set.add(2)).to eq(Set.new(1,2))
      end
    end

    describe "#remove" do
      it "returns a set excluding the new element" do
        set = Set.new(2,1,3)

        expect(set.remove(2)).to eq(Set.new(3,1))
      end
    end

    describe "#==" do
      context "other is not a set" do
        it "returns false" do
          set = Set.new
          other = "hey"

          expect(set == other).to be(false)
        end
      end

      context "self is a subset of other" do
        context "self is a superset of other" do
          it "returns true" do
            set = Set.new

            expect(set == set).to be(true)
          end

          context "self is not a superset of other" do
            it "returns false" do
              set = Set.new

              expect(set == Set.new("justine")).to be(false)
            end
          end
        end
      end

      context "self is a superset of other" do
        context "self is not a super set of other" do
          it "returns false" do
            set = Set.new

            expect(set == Set.new("justine")).to be(false)
          end
        end
      end

      context "self and other are disjoint" do
        it "returns false" do
          set = Set.new

          expect(set == Set.new("justine")).to be(false)
        end
      end
    end

    describe "#subset?" do
    let(:set) { Set.new }

      context "other is not a set" do
        it "returns false" do
          expect(set.subset?("hey")).to be(false)
        end
      end

      context "self is the empty set" do
        it "returns true" do
          expect(set.subset?(Set.new("hey"))).to be(true)
        end
      end

      context "all of the elements in self are in other" do
        let(:set) { Set.new("hey") }

        it "returns true" do
          other = Set.new("hey", "dawg")

          expect(set.subset?(other)).to be(true)
        end
      end

      context "all of the elements in other are in self" do
        let(:set) { Set.new("hey", "dawg") }

        it "returns false" do
          other = Set.new("hey")

          expect(set.subset?(other)).to be(false)
        end
      end

      context "self is the same as other" do
        let(:set) { Set.new("hey") }

        it "returns true" do
          other = Set.new("hey")

          expect(set.subset?(other)).to be(true)
        end
      end

      context "at least one of the elements in self is not in other" do
        let(:set) { Set.new("hey") }

        it "returns false" do
          other = Set.new("dawg")

          expect(set.subset?(other)).to be(false)
        end
      end
    end

    describe "#proper_subset?" do
      let(:set) { Set.new }

      context "other is not a set" do
        it "returns false" do
          expect(set.proper_subset?("other")).to be(false)
        end
      end

      context "self is the empty set" do
        context "other is not the empty set" do
          it "returns true" do
            expect(set.proper_subset?(Set.new("hey"))).to be(true)
          end
        end

        context "other is the empty set" do
          it "returns false" do
            expect(set.proper_subset?(set)).to be(false)
          end
        end
      end

      context "all of the elements in self are in other" do
        let(:set) { Set.new("hey") }

        it "returns true" do
          other = Set.new("hey", "dawg")

          expect(set.proper_subset?(other)).to be(true)
        end
      end

      context "all of the elements in other are in self" do
        let(:set) { Set.new("hey", "dawg") }

        it "returns false" do
          other = Set.new("hey")

          expect(set.proper_subset?(other)).to be(false)
        end
      end

      context "at least one of the elements in self is not in other" do
        let(:set) { Set.new("yo") }

        it "returns false" do
          other = Set.new("dawg")

          expect(set.proper_subset?(other)).to be(false)
        end
      end

      context "self is a subset of other and a superset" do
        let(:set) { Set.new("yo") }

        it "returns false" do
          other = Set.new("yo")

          expect(set.proper_subset?(other)).to be(false)
        end
      end
    end

    describe "#superset?" do
    let(:set) { Set.new }

      context "other is not a set" do
        it "returns false" do
          expect(set.superset?("other")).to be(false)
        end
      end

      context "self is the empty set" do
        it "returns false" do
          other = Set.new("hey")

          expect(set.superset?(other)).to be(false)
        end
      end

      context "all of the elements in self are in other" do
        let(:set) { Set.new("hey") }

        it "returns false" do
          other = Set.new("hey", "dawg")

          expect(set.superset?(other)).to be(false)
        end
      end

      context "all of the elements in other are in self" do
        let(:set) { Set.new("hey", "dawg") }

        it "returns false" do
          other = Set.new("hey")

          expect(set.superset?(other)).to be(true)
        end
      end

      context "self is the same as other" do
        let(:set) { Set.new("hey") }

        it "returns true" do
          other = Set.new("hey")

          expect(set.superset?(other)).to be(true)
        end
      end

      context "at least one of the elements in other is not in self" do
        let(:set) { Set.new("yo", "hey") }

        it "returns false" do
          other = Set.new("dawg", "yo")

          expect(set.superset?(other)).to be(false)
        end
      end
    end

    describe "#proper_superset?" do
      let(:set) { Set.new }

      context "other is not a set" do
        it "returns false" do
          expect(set.proper_superset?("other")).to be(false)
        end
      end

      context "self is the empty set" do
        context "other is not the empty set" do
          it "returns false" do
            other = Set.new("hey")

            expect(set.proper_superset?(other)).to be(false)
          end
        end

        context "other is the empty set" do
          it "returns false" do
            other = Set.new

            expect(set.proper_superset?(other)).to be(false)
          end
        end
      end

      context "all of the elements in other are in self" do
        let(:set) { Set.new("hey", "dawg") }

        it "returns true" do
          other = Set.new("hey")

          expect(set.proper_superset?(other)).to be(true)
        end
      end

      context "at least one of the elements in other is not in self" do
        let(:set) { Set.new("yo", "hey", "son") }

        it "returns false" do
          other = Set.new("dawg", "yo")

          expect(set.proper_superset?(other)).to be(false)
        end
      end

      context "self is a superset of other and a subset of other" do
        let(:set) { Set.new("yo") }

        it "returns false" do
          expect(set.proper_superset?(set)).to be(false)
        end
      end
    end

    describe "#inspect" do
      context "empty set" do
        it "returns the correct representation" do
          set = Set.new

          expect(set.inspect).to eq("Ø")
        end
      end

      context "non empty" do
        it "returns the correct representation" do
          set = Set.new("justine", 4, [1, "hey"], {foo: :bar})

          expect(set.inspect).to eq('{"justine", 4, [1, "hey"], {:foo=>:bar}}')
        end
      end
    end

    describe "#to_s" do
      context "empty set" do
        it "returns the correct representation" do
          set = Set.new

          expect(set.to_s).to eq("Ø")
        end
      end

      context "non empty" do
        it "returns the correct representation" do
          set = Set.new("justine", 4, [1, "hey"], {foo: :bar})

          expect(set.to_s).to eq('{"justine", 4, [1, "hey"], {:foo=>:bar}}')
        end
      end
    end

    describe "#to_a" do
      it "returns an array of the elements in the set" do
        set = Set.new(1,2,3)
        other_set = Set.new(1,1,2,3)

        expect(set.to_a).to eq([1,2,3])
        expect(other_set.to_a).to eq([1,2,3])
      end
    end

    describe "#cardinality" do
      it "returns the length of the set" do
        set = Set.new(1,2,3)
        other_set = Set.new(1,1,2,3)

        expect(set.cardinality).to eq(3)
        expect(other_set.cardinality).to eq(3)
      end
    end

    describe "#member?" do
      context "set does not contain supplied element" do
        it "returns false" do
          set = Set.new(1,2,3)

          expect(set.member?(4)).to be(false)
        end
      end

      context "set contains supplied element" do
        it "returns true" do
          set = Set.new(1,2,3)

          expect(set.member?(2)).to be(true)
        end
      end
    end

    describe "#union" do
      context "other is not a set" do
        it "raises an argument error" do
          set = Set.new
          other = "hey"

          expect { set.union(other) }.to raise_error(
            ArgumentError,
            "Argument must be a BetterSet",
          )
        end
      end

      it "returns a set with all the elements from both sets" do
        set = Set.new(1,2,3)
        set2 = Set.new("hey", 3, Set.new)

        expect(set.union(set2)).to eq(
          Set.new(1, 2, 3, "hey", Set.new)
        )
      end
    end

    describe "#intersection" do
      context "other is not a set" do
        it "raises an argument error" do
          set = Set.new
          other = "hey"

          expect { set.intersection(other) }.to raise_error(
            ArgumentError,
            "Argument must be a BetterSet",
          )
        end
      end

      it "returns a set with only the elements in both sets" do
        set = Set.new(1,Set.new, 3)
        set2 = Set.new("hey", 3, Set.new)

        expect(set.intersection(set2)).to eq(
          Set.new(3, Set.new)
        )
      end
    end

    describe "#difference" do
      context "other is not a set" do
        it "raises an argument error" do
          set = Set.new
          other = "hey"

          expect { set.difference(other) }.to raise_error(
            ArgumentError,
            "Argument must be a BetterSet",
          )
        end
      end

      it "returns a set with all the elements in self but not in other" do
        set = Set.new(1,Set.new, 3)
        set2 = Set.new("hey", 3, Set.new)

        expect(set.difference(set2)).to eq(
          Set.new(1)
        )
      end
    end

    describe "#-" do
      context "other is not a set" do
        it "raises an argument error" do
          set = Set.new
          other = "hey"

          expect { set - other }.to raise_error(
            ArgumentError,
            "Argument must be a BetterSet",
          )
        end
      end

      it "returns a set with all the elements in self but not in other" do
        set = Set.new(1,Set.new, 3)
        set2 = Set.new("hey", 3, Set.new)

        expect(set - set2).to eq(
          Set.new(1)
        )
      end
    end

    describe "empty?" do
      context "it is empty" do
        it "returns false" do
          set = Set.new(1)

          expect(set.empty?).to be(false)
        end
      end

      context "it is empty" do
        it "returns false" do
          set = Set.new

          expect(set.empty?).to be(true)
        end
      end
    end

    describe "#powerset" do
      it "returns the set of all subsets of self" do
        set = Set.new
        set2 = Set.new(1,2)

        expect(set.powerset).to eq(Set.new(Set.new))
        expect(set2.powerset).to eq(Set.new(
          Set.new,
          Set.new(1),
          Set.new(2),
          Set.new(1,2),
        ))
      end
    end

    describe "#cartesian_product" do
      context "other is not a set" do
        it "raises an argument error" do
          set = Set.new
          other = "hey"

          expect { set.cartesian_product(other) }.to raise_error(
            ArgumentError,
            "Argument must be a BetterSet",
          )
        end
      end

      it "returns the cartesian product of two sets as a relation" do
        domain = Set.new(1,2)
        range = Set.new(3,4)
        ordered_pair = OrderedPair.new(1,3)
        ordered_pair2 = OrderedPair.new(1,4)
        ordered_pair3 = OrderedPair.new(2,3)
        ordered_pair4 = OrderedPair.new(2,4)
        ordered_pairs = Set.new(
          ordered_pair,
          ordered_pair2,
          ordered_pair3,
          ordered_pair4
        )
        relation = Relation.new(ordered_pairs)

        expect(domain.cartesian_product(range)).to eq(relation)
      end
    end

    describe "#partition" do
      it "divides the given set by the supplied block" do
        set = Set.new(1,2,3,4,5,6,7,8,9,10)
        even_set = set.select(&:even?)
        odd_set = set.select(&:odd?)

        expect(set.partition(&:even?)).to eq(Set.new(
          even_set,
          odd_set,
        ))
      end
    end

    describe "#arbitrary_element" do
      let(:array) { [1,2,3,4] }
      let(:set) { Set.new(*array) }

      subject(:arbitrary_element) { set.arbitrary_element }

      it "picks an element from the set" do
        expect(array).to include(arbitrary_element)
      end

      it "doesnt return a new value on next call" do
        element1 = set.arbitrary_element
        element2 = set.arbitrary_element

        expect(arbitrary_element).to eq(element1)
        expect(arbitrary_element).to eq(element2)
      end
    end
  end
end
