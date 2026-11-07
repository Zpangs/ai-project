from django.http import JsonResponse

def api_status(request):
    return JsonResponse({"message": "Kopplingen mellan React och Django fungerar!", "status": "success"})
