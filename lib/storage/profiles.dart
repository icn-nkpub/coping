import 'package:supabase/supabase.dart';

getProfile(user) async {
  final supabase = SupabaseClient('supabaseUrl', 'supabaseKey');

  // Select from table `countries` ordering by `name`
  final data =
      await supabase.from('countries').select().order('name', ascending: true);
}
