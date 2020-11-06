theory Hello
  imports 
    Main
begin

value "''Hello World''"

fun hi :: "nat \<Rightarrow> nat" where
  "hi x = x * 4"

text_raw \<open> \Snip{Eg} \<close> 
fun snippet :: "nat \<Rightarrow> nat" where
  "snippet x = x * 10"
text_raw \<open> \EndSnip \<close> 

end