require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")

describe "Factorial" do
  before do
    @memory = UrCPU::Memory.new
    
    @memory.set_section("text")
    @memory.set_label(:start)
        @memory.concat [
          :call_lbl, :fact,
          :hlt
        ]
    @memory.set_label(:fact)
        @memory.concat [
          :mov_reg_reg, :eax, :ecx,
          :mov_imm_reg, 1, :eax,
        ]
        @memory.set_label(:fact_loop)
            @memory.concat [
              :cmp_imm_reg, 0, :ecx,
              :jz_lbl, :fact_done,
              :mov_reg_reg, :ecx, :ebx,
              :push_reg, :ecx,
              :call_lbl, :mult,
              :pop_reg, :ecx,
              :sub_imm_reg, 1, :ecx,
              :jmp_lbl, :fact_loop,
            ]
        @memory.set_label(:fact_done)
            @memory.concat [
              :ret
            ]
    @memory.set_label(:mult)
        @memory.concat [
          :mov_reg_reg, :ebx, :ecx,
          :mov_reg_reg, :eax, :ebx,
          :xor_reg_reg, :eax, :eax,
          :cmp_imm_reg, 0, :ecx,
          :jz_lbl, :mult_done,
        ]
    @memory.set_label(:mult_loop)
        @memory.concat [
          :add_reg_reg, :ebx, :eax,
          :sub_imm_reg, 1, :ecx,
          :jnz_lbl, :mult_loop,
        ]
    @memory.set_label(:mult_done)
        @memory.concat [
          :ret
        ]
        
    @memory.set_section("data")
    @memory.set_section("stack")
            
    @cpu = UrCPU::Core.new(@memory)
  end
  
  def fact(n)
    (1 .. n).inject(1) { |p,k| p * k }
  end

  (0 .. 10).each do |n|
    it "computes the factorial of N=#{n}" do
      @cpu.registers[:eax] = n
      @cpu.run
      @cpu.registers[:eax].should == fact(n)
    end
  end
end
