part of presentation;

class OverlayPermissionPage extends StatelessWidget {
  const OverlayPermissionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: ColorApp.backgroundColor
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Center(
              child: SizedBox(
                width: 300,
                height: 300,
                child: RiveAnimation.asset(
                  'assets/anims/overlayapp.riv',
                  fit: BoxFit.contain,
                  stateMachines: [
                    'State 1'
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            SizedBox(
              width: context.width * .8,
              child: Text(
                context.translate.get('intro.overlayPermission'),
                style: TextStyle(
                  color: ColorApp.mainColor,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      ),
    );
  }
}
