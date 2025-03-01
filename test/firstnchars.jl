using Test

using DocumenterDescriptions

describer = FirstNCharsDescriber(; nchars = 160)


less_than_160 = "# Some Page \n This page is less than 160 characters"
desc_less_than_160 = describer(less_than_160)

@test length(desc_less_than_160) < 160

