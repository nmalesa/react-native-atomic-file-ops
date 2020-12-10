export default function(spec) {

  spec.describe('Logging in', function() {

    spec.it('works', async function() {
      await spec.exists('LoginScreen');
      await spec.fillIn('LoginScreen.EmailInput', 'cavy@example.com');
      await spec.fillIn('LoginScreen.PasswordInput', 'password');
      await spec.press('LoginScreen.Button');
      await spec.exists('WelcomeScreen');
    });
  });
}