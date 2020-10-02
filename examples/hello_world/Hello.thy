theory Hello
  imports 
    Main
begin

value "''Hello World''"

fun hi :: "nat \<Rightarrow> nat" where
  "hi x = x * 4"

end