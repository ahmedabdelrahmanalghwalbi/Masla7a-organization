import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:maslaha/screens/profile/profile_screen.dart';

getServiceProviderProfile(BuildContext context,String serviceProviderId){
  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ProfileScreen(serviceProviderId: serviceProviderId,)));
}