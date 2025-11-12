# 1. get an input of 7 chars                                    abcdeab
# 2. get a string of 2 chars to find...                         ac
# 3. ...and replace with an additional 2 chars if found         xy
# 4. print out the string                                        abcdeab # no change because ac isnt found
# 5. repeat until halt character


def built_in_funcs():
    while True:
        # 1. get input
        base_string:str = input("Input characters: ")[:7]

        # 5. check if input is #
        if base_string == "#":
            break

        # continue getting input
        find:str = input("Find: ") # 2
        replace:str = input("Replace: ") # 3

        # replace characters in string 
        base_string = base_string.replace(find, replace) # 3

        # 4
        print(base_string)

    print("Exit.")

