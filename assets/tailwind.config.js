module.exports = {
      content: [
        './js/**/*.js',
        '../lib/*_web.ex',
        '../lib/*_web/**/*.*ex',
      ],
      theme: {
        extend: {},
      },
      plugins: [],
      extend: {
        screens: {
            print: { raw: 'print'},
            screen: {raw: 'screen'}
        }
      }
    }