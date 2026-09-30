class Book:
    def __init__(self, id, name, quantity):
        self.id = id
        self.name = name
        self.quantity = int(quantity)

class User:
    def __init__(self, id, name):
        self.id = id
        self.name = name

class Admin:
    def __init__(self):
        self.books = []  # book object
        self.users = {}  # user object as a key

    def add_book(self, book_id, book_name, book_quantity):
        for book in self.books:
            if book.id == book_id:
                return print("This book is already exist")
        new_book = Book(book_id, book_name, book_quantity)
        self.books.append(new_book)
        print("Book is added successfully")

    def print_all_books(self):
        lst_of_books = []
        for book in self.books:
            lst_of_books.append(book.name)
        if not lst_of_books:
            return f"There are no books"
        return ", ".join(lst_of_books)

    def search_for_book(self, query):
        found_books = [book.name for book in self.books if book.name[:len(query)].upper() == query.upper()]
        if not found_books:
            return f"No book found"
        return found_books

    def add_user(self, user_id, user_name):
        for user in self.users:
            if user.id == user_id:
                return print(f"This user already exist !")
        new_user = User(user_id, user_name)
        self.users[new_user] = None
        print("User created successfully !")

    def borrow_book(self, user_name, book_name):
        found_book = ''.join(self.search_for_book(book_name))
        user_found = False
        available_books = [book for book in self.books if book.name == found_book and book.quantity > 0]
        if not available_books:
            return print("Insufficient quantity!")
        available_books[0].quantity -= 1
        for user, values in self.users.items():
            if user.name.lower() == user_name.lower():
                if values is None:
                    self.users[user] = [book_name]
                else:
                    self.users[user].append(book_name)
                user_found = True
        if not user_found:
            return print('There is no user with this name')
        return print(F'The user {user_name} borrowed {found_book}')

    def return_book(self, user_name, book_name):
        found_book = ''.join(self.search_for_book(book_name))
        user_found = False
        available_books = [book for book in self.books if book.name == found_book]
        if not available_books:
            return print("There is no book with this name")
        available_books[0].quantity += 1
        for user, values in self.users.items():
            if user.name.lower() == user_name.lower():
                if len(values) == 1:
                    self.users[user] = None
                else:
                    self.users[user].remove(book_name)
                user_found = True
        if not user_found:
            return print('There is no user with this name')
        return print(F'The user {user_name} returned {found_book}')

    def print_users_borrowed(self):
        users_found = [user for user in self.users if self.users[user] is not None]
        if users_found:
            for user in users_found:
                print(f'The user {user.name} borrowed the books {" and ".join(self.users[user])}')
        else:
            print('There are no users borrowed any book')

    def print_all_users(self):
        all_users = [user.name for user in self.users]
        if all_users:
            for user in all_users:
                print(user, end=' ')

class OperationsManager:
    def __init__(self):
        self.admin = Admin()

    def print_menu(self):
        print("Program Options: ")
        options = [
            '1) Add book',
            '2) Print library books',
            '3) Print books by prefix',
            '4) Add user',
            '5) Borrow book',
            '6) Return book',
            '7) Print users borrowed book',
            '8) Print users'
        ]
        print('\n'.join(options))
        return self.get_choice(len(options))

    def get_choice(self, num_options):
        msg = f"Enter your choice from 1 to {num_options} \n"
        return input_is_valid(msg, 1, num_options)

    def add_book(self):
        book_id = input('Please Enter the book id: \n')
        book_name = input('Please Enter the book name: \n')
        book_quantity = input('Please Enter the book quantity: \n')
        self.admin.add_book(book_id, book_name, book_quantity)

    def print_books(self):
        print(self.admin.print_all_books())

    def search_books(self):
        query = input('Enter your query: \n')
        print(', '.join(self.admin.search_for_book(query)))

    def add_user(self):
        user_id = int(input('Enter user id: \n'))
        user_name = input('Enter user name: \n')
        self.admin.add_user(user_id, user_name)

    def borrow_book(self):
        user_name = input('Enter user name: \n')
        book_name = input('Enter book name: \n')
        self.admin.borrow_book(user_name, book_name)

    def return_book(self):
        user_name = input('Enter user name: \n')
        book_name = input('Enter book name: \n')
        self.admin.return_book(user_name, book_name)

    def print_users_borrowed(self):
        self.admin.print_users_borrowed()

    def print_all_users(self):
        self.admin.print_all_users()

    def run(self):
        while True:
            choice = self.print_menu()

            if choice == 1:
                self.add_book()
            elif choice == 2:
                self.print_books()
            elif choice == 3:
                self.search_books()
            elif choice == 4:
                self.add_user()
            elif choice == 5:
                self.borrow_book()
            elif choice == 6:
                self.return_book()
            elif choice == 7:
                self.print_users_borrowed()
            elif choice == 8:
                self.print_all_users()
            else:
                print("Exiting the program.")
                break

def input_is_valid(msg, start=0, end=None):
    while True:
        inp = input(msg)

        if not inp.isdecimal():
            print("Invalid input. Try again!")

        elif start is not None and end is not None:
            if not (start <= int(inp) <= end):
                print("Invalid range. Try again!")
            else:
                return int(inp)

        else:
            return int(inp)

if __name__ == '__main__':
    main = OperationsManager()
    main.run()
