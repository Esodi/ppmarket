from django.core.management.base import BaseCommand
from saleor.account.models import User


class Command(BaseCommand):
    help = "Interactively confirm and activate a user account"

    def handle(self, *args, **options):
        users = list(User.objects.all())

        if not users:
            self.stdout.write(self.style.WARNING("No users found."))
            return

        self.stdout.write("\nRegistered users:")
        for idx, user in enumerate(users):
            self.stdout.write(f"[{idx}] {user.email} (Confirmed: {user.is_confirmed}, Active: {user.is_active})")

        try:
            selected_index = int(input("\nEnter the index of the user to confirm: "))
            selected_user = users[selected_index]
        except (IndexError, ValueError):
            self.stdout.write(self.style.ERROR("Invalid index. Exiting."))
            return

        selected_user.is_active = True
        selected_user.is_confirmed = True
        selected_user.save(update_fields=["is_active", "is_confirmed", "updated_at"])

        self.stdout.write(self.style.SUCCESS(f"✅ User '{selected_user.email}' has been confirmed and activated."))
